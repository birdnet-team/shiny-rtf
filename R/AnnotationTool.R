# annotation_app()
#
# To do: maybe save empty lines for files with no annotations (as an option - add a box to tick under "general")

# Start with a fresh R session and run the command options(shiny.reactlog=TRUE)
# Then run your app in a show case mode: runApp('inst/shiny/formant_app', display.mode = "showcase")
# At any time you can hit Ctrl+F3 (or for Mac users, Command+F3) in your web browser to launch the reactive log visualization.
#
# shinyBS needs to be included as a dependency (instead of just "import"):
# see https://stackoverflow.com/questions/52649138/including-shinybs-in-a-package

server = function(input, output, session) {
  # make plots resizable (js fix)
  shinyjs::js$inheritSize(parentDiv = 'specDiv')

  # set max upload file size to 30 MB
  options(shiny.maxRequestSize = 30 * 1024 ^ 2)

  myPars = reactiveValues(
    print = FALSE,          # if TRUE, some functions print a message to the console when called
    debugQn = FALSE,             # for debugging - click "?" to step into the code
    zoomFactor = 2,         # zoom buttons change time zoom by this factor
    zoomFactor_freq = 1.5,  # same for frequency
    shinyTip_show = 1000,      # delay until showing a tip (ms)
    shinyTip_hide = 0,         # delay until hiding a tip (ms)
    initDur = 2000,            # initial duration to plot (ms)
    spec_xlim = c(0, 2000),
    out_spects = list(),       # a list for storing spectrograms
    slider_ms = 50,            # how often to update play slider
    scrollFactor = .75,        # how far to scroll on arrow press/click
    wheelScrollFactor = .1,    # how far to scroll on mouse wheel (prop of xlim)
    samplingRate_idx = 1,      # sampling rate scaling index for playback
    listen_alphanum = TRUE,    # enable/disable alphanumeric hotkeys
    listen_enter = FALSE,      # enable/disable ENTER to close modal (new annotation)
    listen_enter_edit = FALSE, # ENTER to edit an existing annotation
    cursor = 0,
    play = list(on = FALSE)
  )

  # NB: using myPars$play$cursor for some reason invalidates the observer,
  # so it keeps executing as fast as it can - no idea why!

  # clean-up of www/ folder: remove all files except temp.wav
  # if (!dir.exists("www")) dir.create("www")  # otherwise trouble with shinyapps.io
  if (file.exists('www/temp.csv')) {
    showModal(modalDialog(
      title = "Unsaved data",
      "Found unsaved data from a prevous session. Append to the new output?",
      easyClose = TRUE,
      footer = tagList(
        actionButton("discard", "Discard"),
        actionButton("append", "Append")
      )
    ))
  }
  observeEvent(input$discard, {
    file.remove('www/temp.csv')
    removeModal()
  })
  observeEvent(input$append, {
    myPars$out = try(read.csv('www/temp.csv', stringsAsFactors = FALSE))
    removeModal()
  })

  files = list.files('www/', pattern = '.wav')
  for (f in files){
    file.remove(paste0('www/', f))
  }

  reset = function() {
    if (myPars$print) print('Resetting...')
    myPars$ann = NULL         # a dataframe of annotations for the current file
    myPars$currentAnn = NULL  # the idx of currently selected annotation
    myPars$bp = NULL          # selected points (under brush)
    myPars$spec = NULL
    myPars$spec_trimmed = NULL
    myPars$selection = NULL
    myPars$cursor = 0
    myPars$spectrogram_brush = NULL
    shinyjs::js$clearBrush(s = '_brush')
  }

  resetSliders = function() {
    if (myPars$print) print('Resetting sliders...')
    sliders_to_reset = names(input)[which(names(input) %in% rownames(def_form))]
    for (v in sliders_to_reset) {
      new_value = def_form[v, 'default']
      try(updateSliderInput(session, v, value = new_value))
      try(updateNumericInput(session, v, value = new_value))
      updateSelectInput(session, 'wn', selected = 'gaussian')
      updateSliderInput(session, 'spec_ylim',
                        value = c(0, def_form['spec_ylim','default']))
      updateSliderInput(session, 'spectrum_xlim',
                        value = c(0, def_form['spectrum_xlim','default']))
      updateRadioButtons(session, 'spec_colorTheme', selected='bw')
      updateSelectInput(session, 'osc', selected = 'linear')
    }
  }
  observeEvent(input$reset_to_def, resetSliders())

  loadAudio = function() {
    # shinyjs::js$inheritSize(parentDiv = 'specDiv')
    if (myPars$print) print('Loading audio...')
    done()
    reset()  # also triggers done(), but done() needs to run first in case loadAudio
    # is re-executed (need to save myPars$ann --> myPars$out)

    # if there is a csv among the uploaded files, use the annotations in it
    ext = substr(input$loadAudio$name,
                 (nchar(input$loadAudio$name) - 2),
                 nchar(input$loadAudio$name))
    old_out_idx = which(ext == 'csv')[1]  # grab the first csv, if any
    if (!is.na(old_out_idx)) {
      user_ann = read.csv(input$loadAudio$datapath[old_out_idx], stringsAsFactors = FALSE)
      oblig_cols = c('file', 'from', 'to')
      if (nrow(user_ann) > 0 &
          !any(!oblig_cols %in% colnames(user_ann))) {
        idx_missing = which(apply(user_ann[, oblig_cols], 1, function(x) any(is.na(x))))
        if (length(idx_missing) > 0) user_ann = user_ann[-idx_missing, ]
        if (nrow(user_ann) > 0) {
          if (is.null(myPars$out)) {
            myPars$out = user_ann
          } else {
            myPars$out = soundgen:::rbind_fill(myPars$out, user_ann)
            # remove duplicate rows
            myPars$out = unique(myPars$out)
          }
        }
      }
    }

    # work only with audio files
    idx_audio = which(apply(matrix(input$loadAudio$type), 1, function(x) {
      grepl('audio', x, fixed = TRUE)
    }))
    if (length(idx_audio) > 0) {
      if (is.null(myPars$fileList)) {
        myPars$fileList = input$loadAudio[idx_audio, ]
        myPars$n = 1   # file number in queue
      } else {
        sameFiles = which(myPars$fileList$name %in% input$loadAudio$name)
        if (length(sameFiles) > 0) {
          message('Note: uploading the same audio file twice overwrites previous annotations')
          if (!is.null(myPars$out)) {
            myPars$out = myPars$out[!myPars$out$file %in% myPars$fileList$name[sameFiles]]
            if (length(myPars$out) == 0) myPars$out = NULL
          }
          myPars$fileList = myPars$fileList[-sameFiles, ]
        }
        myPars$n = nrow(myPars$fileList) + 1
        myPars$fileList = rbind(myPars$fileList, input$loadAudio[idx_audio, ])
      }
      myPars$nFiles = nrow(myPars$fileList)  # number of uploaded files in queue
      choices = as.list(myPars$fileList$name)
      names(choices) = myPars$fileList$name
      if (input$fileList == myPars$fileList$name[myPars$n])
        readAudio(myPars$n)  # doesn't fire automatically if the same as before
      updateSelectInput(session, 'fileList',
                        choices = as.list(myPars$fileList$name),
                        selected = myPars$fileList$name[myPars$n])
    } else if(!is.na(old_out_idx)) {
      # only a new csv uploaded - just refresh the current file
      readAudio(myPars$n)
    }
  }
  observeEvent(input$loadAudio, loadAudio())

  observeEvent(input$showpanel, {
    if(input$showpanel == TRUE) {
      shinyjs::removeCssClass("Main", "col-sm-12")
      shinyjs::addCssClass("Main", "col-sm-8")
      shinyjs::show(id = "Sidebar")
      shinyjs::enable(id = "Sidebar")
    }
    else {
      shinyjs::removeCssClass("Main", "col-sm-8")
      shinyjs::addCssClass("Main", "col-sm-12")
      shinyjs::hide(id = "Sidebar")
    }
  })

  readAudio = function(i) {
    # reads an audio file with tuneR::readWave
    if (myPars$print) print('Reading audio...')
    temp = myPars$fileList[i, ]
    myPars$myAudio_filename = temp$name
    myPars$myAudio_path = temp$datapath
    myPars$myAudio_type = temp$type

    extension = substr(myPars$myAudio_filename,
                       nchar(myPars$myAudio_filename) - 2,
                       nchar(myPars$myAudio_filename))
    if (extension == 'wav' | extension == 'WAV') {
      myPars$temp_audio = tuneR::readWave(temp$datapath)
    } else if (extension == 'mp3' | extension == 'MP3') {
      myPars$temp_audio = tuneR::readMP3(temp$datapath)
    } else {
      warning('Input not recognized: must be a wav or mp3 file')
    }

    myPars$myAudio = as.numeric(myPars$temp_audio@left)
    myPars$ls = length(myPars$myAudio)
    myPars$samplingRate = myPars$temp_audio@samp.rate
    myPars$maxAmpl = 2 ^ (myPars$temp_audio@bit - 1)
    if (input$normalizeInput) {
      myPars$myAudio = myPars$myAudio / max(abs(myPars$myAudio)) * myPars$maxAmpl
    }
    myPars$nyquist = myPars$samplingRate / 2 / 1000
    # updateSliderInput(session, 'spec_ylim',
    #                   value = c(0, min(def_form['spec_ylim', 'default'], myPars$nyquist)),
    #                   max = myPars$nyquist)
    # updateSliderInput(session, 'spectrum_xlim',
    #                   value = c(0, min(def_form['spectrum_xlim', 'default'], myPars$nyquist)),
    #                   max = myPars$nyquist)
    myPars$dur = length(myPars$temp_audio@left) * 1000 / myPars$temp_audio@samp.rate
    myPars$time = seq(1, myPars$dur, length.out = myPars$ls)
    myPars$spec_xlim = c(0, min(myPars$initDur, myPars$dur))
    if (!is.finite(myPars$spec_xlim[2])) browser()  # weird glitches
    myPars$regionToAnalyze = myPars$spec_xlim

    # shorten window and step if the input is very short
    max_win = round(myPars$dur / 2)
    if (input$windowLength > myPars$dur) {
      updateNumericInput(session, 'windowLength', value = max_win)
      updateNumericInput(session, 'step', value = max_win / 2)
    }

    # update info - file number ... out of ...
    updateSelectInput(session, 'fileList',
                      label = NULL,
                      selected = myPars$fileList$name[myPars$n])
    file_lab = paste0('File ', myPars$n, ' of ', myPars$nFiles)
    output$fileN = renderUI(HTML(file_lab))

    # if we've already worked with this file,
    # re-load the annotations and (if in current session) spectrogram
    idx = which(myPars$out$file == myPars$myAudio_filename)
    if (length(idx) > 0) {
      myPars$ann = myPars$out[idx, ]
      myPars$currentAnn = 1
    } else {
      myPars$ann = NULL
    }
    myPars$spec = myPars$out_specs[[myPars$myAudio_filename]]

    drawAnn()
    # drawAnnTbl()
  }

  extractSpectrogram = observe({
    # Instead of re-loading the file every time, could save the spectrogram
    # matrix and re-draw manually with soundgen:::filled.contour.mod
    if (!is.null(myPars$myAudio)) {  # & is.null(myPars$spec)
      if (myPars$print) print('Extracting spectrogram...')
      temp_spec = try(soundgen::spectrogram(
        myPars$myAudio,
        samplingRate = myPars$samplingRate,
        dynamicRange = input$dynamicRange,
        windowLength = input$windowLength,
        step = input$step,
        wn = input$wn,
        zp = 2 ^ input$zp,
        contrast = input$specContrast,
        brightness = input$specBrightness,
        blur = c(input$blur_freq, input$blur_time),
        specType = input$specType,
        output = 'processed',
        plot = FALSE
      ))
      if (!inherits(temp_spec, 'try-error') &&
          length(temp_spec) > 0 &&
          is.matrix(temp_spec))
        myPars$spec = temp_spec
    }
  })

  writeAudioFile = observeEvent(c(myPars$temp_audio, myPars$samplingRate), {
    if (myPars$print) print('Writing audio file...')
    # Method: saves a temporary audio file in 'www/'. This is a workaround since
    # html tag for some reason cannot play myPars$myAudio_path (although feeding
    # it to spectrogram works - so probably only works within R). Alternatives:
    # soundgen::play() or shinyFiles library

    # first remove the previous sound file to avoid cluttering up the www/ folder
    if (!is.null(myPars$myfile)){
      file.remove(paste0('www/', myPars$myfile))
    }
    randomID = paste(sample(c(letters, 0:9), 8, replace = TRUE), collapse = '')
    myPars$myfile = paste0(randomID, '.wav')
    # this is the new sound file. NB: has to be saved in www/ !!!
    seewave::savewav(myPars$temp_audio,
                     f = myPars$samplingRate,
                     filename = paste0('www/', myPars$myfile))
    output$htmlAudio = renderUI(
      tags$audio(src = myPars$myfile, type = myPars$myAudio_type,
                 id = 'myAudio',
                 style = "display: none;")
    )
  }, ignoreInit = TRUE)

  # Updating spec / osc stuff to speed up plotting
  observe({
    if (!is.null(myPars$myAudio)) {
      # if (myPars$print) print('Scaling audio...')
      if (input$osc == 'dB') {
        myPars$myAudio_scaled = osc(
          myPars$myAudio,
          dynamicRange = input$dynamicRange,
          dB = TRUE,
          maxAmpl = myPars$maxAmpl,
          plot = FALSE,
          returnWave = TRUE)
        myPars$ylim_osc = c(-2 * input$dynamicRange, 0)
      } else {
        myPars$myAudio_scaled = myPars$myAudio
        myPars$ylim_osc = c(-myPars$maxAmpl, myPars$maxAmpl)
      }
    }
  })

  observe({
    # Cut just the part of spec currently needed for plotting
    # (faster than plotting a huge matrix with xlim/ylim)
    if (!is.null(myPars$spec) & !is.null(myPars$myAudio_scaled)) {
      if (myPars$print) print('Trimming the spec & osc')
      # spec
      x = as.numeric(colnames(myPars$spec))
      idx_x = which(x >= (myPars$spec_xlim[1] / 1.05) &
                      x <= (myPars$spec_xlim[2] * 1.05))
      # 1.05 - a bit beyond b/c we use xlim/ylim and may get white space
      y = as.numeric(rownames(myPars$spec))
      idx_y = which(y >= (input$spec_ylim[1] / 1.05) &
                      y <= (input$spec_ylim[2] * 1.05))
      myPars$spec_trimmed = downsample_spec(
        myPars$spec[idx_y, idx_x],
        maxPoints = 10 ^ input$spec_maxPoints)
      # dim(myPars$spec_trimmed)

      # osc
      idx_s = max(1, (myPars$spec_xlim[1] / 1.05 * myPars$samplingRate / 1000)) :
        min(myPars$ls, (myPars$spec_xlim[2] * 1.05 * myPars$samplingRate / 1000))
      downs_osc = 10 ^ input$osc_maxPoints

      isolate({
        myPars$myAudio_trimmed = myPars$myAudio_scaled[idx_s]
        myPars$time_trimmed = myPars$time[idx_s]
        myPars$ls_trimmed = length(myPars$myAudio_trimmed)
        if (!is.null(myPars$myAudio_trimmed) &&
            myPars$ls_trimmed > downs_osc) {
          myseq = round(seq(1, myPars$ls_trimmed,
                            length.out = downs_osc))
          myPars$myAudio_trimmed = myPars$myAudio_trimmed[myseq]
          myPars$time_trimmed = myPars$time_trimmed[myseq]
          myPars$ls_trimmed = length(myseq)
        }
      })
    }
  })

  downsample_sound = function(x, maxPoints) {
    if (!is.null(myPars$myAudio_trimmed) &&
        myPars$ls_trimmed > (10 ^ input$osc_maxPoints)) {
      if (myPars$print) print('Downsampling osc')
      myseq = round(seq(1, myPars$ls_trimmed,
                        by = myPars$ls_trimmed / input$osc_maxPoints))
      myPars$myAudio_trimmed = myPars$myAudio_trimmed[myseq]
      myPars$ls_trimmed = length(myseq)
    }
  }

  downsample_spec = function(x, maxPoints) {
    lxy = nrow(x) * ncol(x)
    if (length(lxy) > 0 && lxy > maxPoints) {
      if (myPars$print) print('Downsampling spectrogram...')
      lx = ncol(x)  # time
      ly = nrow(x)  # freq
      downs = sqrt(lxy / maxPoints)
      seqx = round(seq(1, lx, length.out = lx / downs))
      seqy = round(seq(1, ly, length.out = ly / downs))
      out = x[seqy, seqx]
    } else {
      out = x
    }
    return(out)
  }


  #################
  ### P L O T S ###
  #################

  ## SPECTROGRAM
  output$spectrogram = renderPlot({
    if (!is.null(myPars$spec)) {
      if (myPars$print) print('Drawing spectrogram...')
      par(mar = c(0.2, 2, 0.5, 2))  # no need to save user's graphical par-s - revert to orig on exit
      if (is.null(myPars$spec)) {
        plot(1:10, type = 'n', bty = 'n', axes = FALSE, xlab = '', ylab = '')
        text(x = 5, y = 5,
             labels = 'Upload wav/mp3 file(s) to begin...\nSuggested max duration ~30 s')
      } else {
        if (input$spec_colorTheme == 'bw') {
          color.palette = function(x) gray(seq(from = 1, to = 0, length = x))
        } else if (input$spec_colorTheme == 'seewave') {
          color.palette = seewave::spectro.colors
        } else {
          colFun = match.fun(input$spec_colorTheme)
          color.palette = function(x) rev(colFun(x))
        }
        soundgen:::filled.contour.mod(
          x = as.numeric(colnames(myPars$spec_trimmed)),
          y = as.numeric(rownames(myPars$spec_trimmed)),
          z = t(myPars$spec_trimmed),
          levels = seq(0, 1, length = 30),
          color.palette = color.palette,
          log = if (input$spec_yScale == 'log') 'y' else '',
          yScale = if (input$spec_yScale %in% c('bark', 'mel', 'ERB')) input$spec_yScale else 'orig',
          xlim = myPars$spec_xlim,
          xaxt = 'n',
          xaxs = 'i', xlab = '',
          ylab = '',
          main = '',
          ylim = input$spec_ylim
        )

        # Add text label of file name
        if (input$spec_yScale == 'bark') {
          spec_ylim = tuneR::hz2bark(input$spec_ylim * 1000)
          nyquist = tuneR::hz2bark(myPars$samplingRate / 2)
        } else if (input$spec_yScale == 'mel') {
          spec_ylim = tuneR::hz2mel(input$spec_ylim * 1000)
          nyquist = tuneR::hz2mel(myPars$samplingRate / 2)
        } else if (input$spec_yScale == 'ERB') {
          spec_ylim = HzToERB(input$spec_ylim * 1000)
          nyquist = HzToERB(myPars$samplingRate / 2)
        } else {
          spec_ylim = input$spec_ylim
          nyquist = myPars$samplingRate / 2000
        }
        if (spec_ylim[2] > nyquist) spec_ylim[2] = nyquist
        text_y_lab = spec_ylim[2] - diff(spec_ylim) * .01
        text(x = myPars$spec_xlim[1] + diff(myPars$spec_xlim) * .01,
             y = text_y_lab,
             labels = myPars$myAudio_filename,
             adj = c(0, 1))  # left, top
      }
    }
  })

  observeEvent(input$spectrogram_click, {
    myPars$cursor = input$spectrogram_click$x
  })

  observeEvent(input$spectrogram_dblclick, {
    if (!is.null(myPars$spectrogram_brush)) {
      showModal(dataModal_new())
    }
  })

  observeEvent(input$spectrogram_brush, {
    myPars$spectrogram_brush = input$spectrogram_brush
  })


  ## OSCILLOGRAM
  observe({
    output$oscillogram = renderPlot({
      if (!is.null(myPars$myAudio_trimmed)) {
        if (myPars$print) print('Drawing osc...')
        par(mar = c(2, 2, 0, 2))
        plot(myPars$time_trimmed,
             myPars$myAudio_trimmed,
             type = 'l',
             xlim = myPars$spec_xlim,
             ylim = myPars$ylim_osc,
             axes = FALSE, xaxs = "i", yaxs = "i", bty = 'o',
             xlab = 'Time, ms',
             ylab = '')
        box()
        # axis(side = 1)
        time_location = axTicks(1)
        time_labels = soundgen:::convert_sec_to_hms(time_location / 1000, 3)
        axis(side = 1, at = time_location, labels = time_labels)
        if (input$osc == 'dB') {
          axis(side = 4, at = seq(0, input$dynamicRange, by = 10))
          mtext("dB", side = 2, line = 3)
        }
        abline(h = 0, lty = 2)
      }
    }, execOnResize = TRUE)
  })


  ## ANNOTATIONS
  drawAnn = function() {
    output$ann_plot = renderPlot({
      if (myPars$print) print('Drawing annotations...')
      isolate({
        if (!is.null(myPars$ann)) {
          if (nrow(myPars$ann) > 0) {
            par(mar = c(0, 2, 0, 2))
            plot(myPars$time_trimmed,
                 xlim = myPars$spec_xlim,
                 ylim = c(.2, .8),
                 type = 'n',
                 xaxs = "i", yaxs = "i",
                 bty = 'n',
                 axes = FALSE,
                 xlab = '', ylab = ''
            )
            for (i in 1:nrow(myPars$ann)) {
              r = rnorm(1, 0, .05)  # random vertical shift to avoid overlap
              # highlight current annotation
              highlight = ifelse(is.numeric(myPars$currentAnn) &&
                                   i == myPars$currentAnn,
                                 TRUE, FALSE)
              segments(x0 = myPars$ann$from[i],
                       x1 = myPars$ann$to[i],
                       y0 = .5 + r, y1 = .5 + r,
                       lwd = ifelse(highlight, 3, 2),
                       col = ifelse(highlight, 'blue', 'black'))
              segments(x0 = myPars$ann$from[i],
                       x1 = myPars$ann$from[i],
                       y0 = .45 + r, y1 = .55 + r,
                       lwd = ifelse(highlight, 3, 2),
                       col = ifelse(highlight, 'blue', 'black'))
              segments(x0 = myPars$ann$to[i],
                       x1 = myPars$ann$to[i],
                       y0 = .45 + r, y1 = .55 + r,
                       lwd = ifelse(highlight, 3, 2),
                       col = ifelse(highlight, 'blue', 'black'))
              middle_i = mean(as.numeric(myPars$ann[i, c('from', 'to')]))
              text(x = middle_i,
                   y = .5 + r,
                   labels = myPars$ann$label[i],
                   adj = c(.5, 0), cex = 1.5)
            }
            par(mar = c(0.2, 2, 0.5, 2))
          }
        } else if (!is.null(myPars$spec)) {
          par(mar = c(0, 2, 0, 2))
          plot(1:10,
               type = 'n',
               bty = 'n',
               axes = FALSE,
               xlab = '', ylab = '')
          text(5, 5,
               labels = paste('Select a region of spectrogram and double-click',
                              'to create an annotation'))
        }
      })
    })
  }
  observeEvent(c(myPars$spec_xlim, myPars$currentAnn), drawAnn())

  observeEvent(myPars$currentAnn, {
    if (!is.null(myPars$currentAnn)) {
      if (myPars$print) print('Updating selection...')
      sel_points = as.numeric(round(myPars$ann[myPars$currentAnn, c('from', 'to')] /
                                      1000 * myPars$samplingRate))
      # in case of weird times in annotations, keep selection between 0 and audio length
      sel_points[1] = max(0, sel_points[1])
      sel_points[2] = min(sel_points[2], myPars$ls)
      idx_points = sel_points[1]:sel_points[2]
      myPars$selection = myPars$myAudio[idx_points]
      # move the spec view to show the selected ann
      ann_dur = myPars$ann$to[myPars$currentAnn] -
        myPars$ann$from[myPars$currentAnn]
      mid_view = mean(myPars$spec_xlim)
      mid_ann = mean(as.numeric(myPars$ann[myPars$currentAnn, c('from', 'to')]))
      shift = mid_ann - mid_view
      if (myPars$ann$from[myPars$currentAnn] < myPars$spec_xlim[1] |
          myPars$ann$to[myPars$currentAnn] > myPars$spec_xlim[2]) {
        if (diff(myPars$spec_xlim) > ann_dur) {
          # the ann fits based on current zoom level
          myPars$spec_xlim[1] = max(0, myPars$spec_xlim[1] + shift)
          myPars$spec_xlim[2] = min(myPars$dur, myPars$spec_xlim[2] + shift)
        } else {
          # zoom out enough to show the whole ann
          half_span = ann_dur * 1.5 / 2
          myPars$spec_xlim[1] = max(0, mid_ann - half_span)
          myPars$spec_xlim[2] = min(myPars$dur, mid_ann + half_span)
        }
      }
      hr()
    }
  })

  observeEvent(input$ann_click, {
    # select the annotation whose middle (label) is closest to the click
    if (!is.null(myPars$ann)) {
      ds = abs(input$ann_click$x - (myPars$ann$from + myPars$ann$to) / 2)
      myPars$currentAnn = which.min(ds)
      myPars$spectrogram_brush = list(xmin = myPars$ann$from[myPars$currentAnn],
                                      xmax = myPars$ann$to[myPars$currentAnn])
      myPars$cursor = myPars$ann$from[myPars$currentAnn]
    }
  })

  observeEvent(input$ann_dblclick, {
    # select and edit the double-clicked annotation
    if (!is.null(myPars$ann)) {
      ds = abs(input$ann_dblclick$x - (myPars$ann$from + myPars$ann$to) / 2)
      myPars$currentAnn = which.min(ds)
      showModal(dataModal_edit())
    }
  })

  dataModal_new = function() {
    myPars$listen_alphanum = FALSE
    myPars$listen_enter = TRUE
    modalDialog(
      textInput("annotation", "New annotation:",
                placeholder = '...some info...'
      ),
      footer = tagList(
        modalButton("Cancel"),
        actionButton("ok_new", "OK")
      ),
      easyClose = TRUE
    )
  }

  new_annotation = function() {
    if (myPars$print) print('Creating a new annotation...')
    Sys.sleep(0.5)  # wait for 500 ms, otherwise label not saved if OK is clicked too fast (why?)
    new = data.frame(
      # idx = ifelse(is.null(myPars$ann), 1, nrow(myPars$ann) + 1),
      file = myPars$myAudio_filename,
      from = round(myPars$spectrogram_brush$xmin),
      to = round(myPars$spectrogram_brush$xmax),
      label = input$annotation,
      stringsAsFactors = FALSE)
    new[, myPars$ff] = NA

    # depending on the history, there may be more columns in myPars$ann than in
    # the current sel
    if (is.null(myPars$ann)) {
      myPars$ann = new
    } else {
      myPars$ann = soundgen:::rbind_fill(myPars$ann, new)
    }

    # reorder and select the newly added annotation
    ord = order(myPars$ann$from)
    myPars$ann = myPars$ann[ord, ]
    myPars$currentAnn = which(ord == nrow(myPars$ann))

    # clear the selection, close the modal
    removeModal()
    myPars$listen_alphanum = TRUE
    myPars$listen_enter = FALSE
    drawAnn()
    # hr()

    # save a backup in case the app crashes before done() fires
    temp = soundgen:::rbind_fill(myPars$out, myPars$ann)
    temp = temp[order(temp$file), ]
    write.csv(temp, 'www/temp.csv', row.names = FALSE)
  }

  observeEvent(input$ok_new, {
    new_annotation()
  })

  dataModal_edit = function() {
    myPars$listen_alphanum = FALSE
    myPars$listen_enter_edit = TRUE
    modalDialog(
      textInput("annotation", "New annotation:",
                placeholder = '...some info...'
      ),
      footer = tagList(
        modalButton("Cancel"),
        actionButton("ok_edit", "OK")
      ),
      easyClose = TRUE
    )
  }

  edit_annotation = function() {
    myPars$ann$label[myPars$currentAnn] = input$annotation
    removeModal()
    myPars$listen_alphanum = TRUE
    myPars$listen_enter_edit = FALSE
    drawAnn()
    # drawAnnTbl()
  }
  observeEvent(input$ok_edit, edit_annotation())


  observeEvent(myPars$ann, {
    if (myPars$print) print('Drawing ann_table...')
    if (!is.null(myPars$ann)) {
      # ann_for_print = myPars$ann[, which(!colnames(myPars$ann) %in% c('X', 'file'))]
      show_cols = c('from', 'to', 'label')
      ann_for_print = myPars$ann[, show_cols[which(show_cols %in% colnames(myPars$ann))]]
    } else {
      ann_for_print = '...waiting for some annotations...'
    }
    output$ann_table = renderTable(
      format(ann_for_print),
      align = 'c', striped = FALSE,
      bordered = TRUE, hover = FALSE, width = '100%'
    )
    hr()
  }, ignoreNULL = FALSE)

  hr = function() {
    if (!is.null(myPars$currentAnn)) {
      # Sys.sleep(.5)
      session$sendCustomMessage('highlightRow', myPars$currentAnn)
    }
  }

  observeEvent(input$tableRow, {
    if (!is.null(myPars$ann) && input$tableRow > 0) {
      myPars$currentAnn = input$tableRow
      myPars$spectrogram_brush = list(xmin = myPars$ann$from[myPars$currentAnn],
                                      xmax = myPars$ann$to[myPars$currentAnn])
    }
  }, ignoreInit = TRUE)


  ## Buttons for operations with selection
  startPlay = function() {
    if (!is.null(myPars$myAudio)) {
      if (!is.null(input$spectrogram_brush) &&
          (input$spectrogram_brush$xmax - input$spectrogram_brush$xmin > 100)) {
        # at least 100 ms selected
        myPars$play$from = input$spectrogram_brush$xmin / 1000
        myPars$play$to = input$spectrogram_brush$xmax / 1000
      } else {
        myPars$play$from = myPars$spec_xlim[1] / 1000 # myPars$cursor / 1000
        myPars$play$to = myPars$spec_xlim[2] / 1000
      }
      myPars$play$dur = myPars$play$to - myPars$play$from
      myPars$play$timeOn = proc.time()
      myPars$play$timeOff = myPars$play$timeOn + myPars$play$dur / myPars$samplingRate
      myPars$cursor_temp = myPars$cursor
      myPars$play$on = TRUE
      if (myPars$print) print('Playing selection...')

      # play selection
      if (input$audioMethod == 'Browser') {
        # play with javascript
        shinyjs::js$playme_js(  # need an external js script for this
          audio_id = 'myAudio',  # defined in tags$audio
          from = myPars$play$from,
          to = myPars$play$to)
      } else {
        # or play with R:
        playme(myPars$myAudio,
               samplingRate = myPars$samplingRate,
               from = myPars$play$from,
               to = myPars$play$to)
      }
    }
  }
  observeEvent(c(input$selection_play), startPlay())  # add myPars$myAudio for autoplay

  stopPlay = function() {
    myPars$play$on = FALSE
    myPars$cursor = myPars$cursor_temp
    shinyjs::js$stopAudio_js(audio_id = 'myAudio')
  }
  observeEvent(input$selection_stop, stopPlay())

  observe({
    if (!is.null(myPars$play$on) && myPars$play$on) {
      time = proc.time()
      if (!is.null(myPars$slider_ms)) invalidateLater(myPars$slider_ms)
      if ((time - myPars$play$timeOff)[3] > 0) {
        myPars$play$on = FALSE
        myPars$cursor = myPars$cursor_temp  # reset to original cursor
      } else {
        myPars$cursor = myPars$play$from * 1000 + as.numeric(time - myPars$play$timeOn)[3] * 1000 * myPars$samplingRate_idx
        # [3] for "elapsed", ie "real" time
      }
    }
  })

  deleteSel = function() {
    if (!is.null(myPars$currentAnn)) {
      myPars$ann = myPars$ann[-myPars$currentAnn, ]
      myPars$selection = NULL
      myPars$currentAnn = NULL
      drawAnn()
      # drawAnnTbl()
    }
  }
  observeEvent(input$selection_delete, deleteSel())

  observeEvent(input$selection_annotate, {
    if (!is.null(myPars$spectrogram_brush)) {
      showModal(dataModal_new())
    }
  })

  # HOTKEYS
  observeEvent(input$userPressedSmth, {
    button_key = substr(input$userPressedSmth, 1, nchar(input$userPressedSmth) - 8)
    # see https://keycode.info/
    if (button_key == ' ') {                  # SPACEBAR (play / stop)
      if (myPars$play$on) stopPlay() else startPlay()
    } else if (button_key %in% c('Delete', 'Backspace')) {    # DELETE (delete current annotation)
      deleteSel()
    } else if (button_key == 'ArrowLeft') {    # ARROW LEFT (scroll left)
      shiftFrame('left', step = myPars$scrollFactor)
    } else if (button_key == 'ArrowRight') {    # ARROW RIGHT (scroll right)
      shiftFrame('right', step = myPars$scrollFactor)
    } else if (button_key == 'ArrowUp') {       # ARROW UP (horizontal zoom-in)
      changeZoom(myPars$zoomFactor)
    } else if (myPars$listen_alphanum & button_key %in% c('s', 'S')) {    # S (horizontal zoom to selection)
      zoomToSel()
    } else if (button_key == 'ArrowDown') {   # ARROW DOWN (horizontal zoom-out)
      changeZoom(1 / myPars$zoomFactor)
    } else if (button_key == '+') {     # + (vertical zoom-in)
      changeZoom_freq(1 / myPars$zoomFactor_freq)
    } else if (button_key == '-') {    # - (vertical zoom-out)
      changeZoom_freq(myPars$zoomFactor_freq)
    } else if (myPars$listen_alphanum & button_key %in% c('a', 'A')) {  # A (new annotation)
      if (!is.null(myPars$spectrogram_brush))
        showModal(dataModal_new())
    } else if (button_key == 'PageDown') {   # PageDown (next file)
      nextFile()
    } else if (button_key == 'PageUp') {     # PageUp (previous file)
      lastFile()
    } else if ((myPars$listen_enter | myPars$listen_enter_edit) & button_key == 'Enter') {
      if (myPars$listen_enter) {
        new_annotation()
      } else {
        edit_annotation()
      }
    }
  })


  ## ZOOM
  changeZoom_freq = function(coef) {
    # midpoint = mean(input$spec_ylim)
    # halfRan = diff(input$spec_ylim) / 2 / coef
    # newLow = max(0, midpoint - halfRan)
    # newHigh = min(myPars$samplingRate / 2, midpoint + halfRan)
    newHigh = min(input$spec_ylim[2] * coef, myPars$samplingRate / 2 / 1000)
    updateSliderInput(session, 'spec_ylim', value = c(0, newHigh))
  }
  observeEvent(input$zoomIn_freq, changeZoom_freq(1 / myPars$zoomFactor_freq))
  observeEvent(input$zoomOut_freq, changeZoom_freq(myPars$zoomFactor_freq))
  observeEvent(input$spec_ylim, {
    updateSliderInput(session, 'spectrum_xlim', value = input$spec_ylim)
  })

  changeZoom = function(coef, toCursor = FALSE) {
    # intelligent zoom-in a la Audacity: midpoint moves closer to selection/cursor
    if (!is.null(myPars$cursor) & toCursor) {
      if (!is.null(myPars$spectrogram_brush)) {
        midpoint = 3/4 * mean(c(myPars$spectrogram_brush$xmin,
                                myPars$spectrogram_brush$xmax)) +
          1/4 * mean(myPars$spec_xlim)
      } else {
        if (myPars$cursor > 0) {
          midpoint = 3/4 * myPars$cursor + 1/4 * mean(myPars$spec_xlim)
        } else {
          # when first opening a file, zoom in to the beginning
          midpoint = mean(myPars$spec_xlim) / coef
        }
      }
    } else {
      midpoint = mean(myPars$spec_xlim)
    }
    halfRan = diff(myPars$spec_xlim) / 2 / coef
    newLeft = max(0, midpoint - halfRan)
    newRight = min(myPars$dur, midpoint + halfRan)
    myPars$spec_xlim = c(newLeft, newRight)
    # use user-set time zoom in the next audio
    if (!is.null(myPars$spec_xlim) &&
        !any(!is.finite(myPars$spec_xlim)))
      myPars$initDur = diff(myPars$spec_xlim)
  }
  observeEvent(input$zoomIn, changeZoom(myPars$zoomFactor, toCursor = TRUE))
  observeEvent(input$zoomOut, changeZoom(1 / myPars$zoomFactor))
  zoomToSel = function() {
    if (!is.null(myPars$spectrogram_brush)) {
      myPars$spec_xlim = round(c(myPars$spectrogram_brush$xmin,
                                 myPars$spectrogram_brush$xmax))
    }
  }
  observeEvent(input$zoomToSel, {
    zoomToSel()
  })

  shiftFrame = function(direction, step = 1) {
    ran = diff(myPars$spec_xlim)
    shift = ran * step
    if (direction == 'left') {
      newLeft = max(0, myPars$spec_xlim[1] - shift)
      newRight = newLeft + ran
    } else if (direction == 'right') {
      newRight = min(myPars$dur, myPars$spec_xlim[2] + shift)
      newLeft = newRight - ran
    }
    myPars$spec_xlim = c(newLeft, newRight)
    # update cursor when shifting frame, but not when zooming
    myPars$cursor = myPars$spec_xlim[1]
  }
  observeEvent(input$scrollLeft, shiftFrame('left', step = myPars$scrollFactor))
  observeEvent(input$scrollRight, shiftFrame('right', step = myPars$scrollFactor))

  moveSlider = observe({
    if (myPars$print) print('Moving slider')
    width = round(diff(myPars$spec_xlim) / myPars$dur * 100, 2)
    left = round(myPars$spec_xlim[1] / myPars$dur * 100, 2)
    shinyjs::js$scrollBar(  # need an external js script for this
      id = 'scrollBar',  # defined in UI
      width = paste0(width, '%'),
      left = paste0(left, '%')
    )
    myPars$cursor = myPars$spec_xlim[1]
  })

  observeEvent(input$scrollBarLeft, {
    if (!is.null(myPars$spec)) {
      spec_span = diff(myPars$spec_xlim)
      scrollBarLeft_ms = input$scrollBarLeft * myPars$dur
      myPars$spec_xlim = c(max(0, scrollBarLeft_ms),
                           min(myPars$dur, scrollBarLeft_ms + spec_span))
    }
  }, ignoreInit = TRUE)

  observeEvent(input$scrollBarMove, {
    direction = substr(input$scrollBarMove, 1, 1)
    if (direction == 'l') {
      shiftFrame('left', step = myPars$scrollFactor)
    } else if (direction == 'r') {
      shiftFrame('right', step = myPars$scrollFactor)
    }
  }, ignoreNULL = TRUE)

  observeEvent(input$scrollBarWheel, {
    direction = substr(input$scrollBarWheel, 1, 1)
    if (direction == 'l') {
      shiftFrame('left', step = myPars$wheelScrollFactor)
    } else if (direction == 'r') {
      shiftFrame('right', step = myPars$wheelScrollFactor)
    }
  }, ignoreNULL = TRUE)

  observeEvent(input$zoomWheel, {
    direction = substr(input$zoomWheel, 1, 1)
    if (direction == 'l') {
      changeZoom(1 / myPars$zoomFactor)
    } else if (direction == 'r') {
      changeZoom(myPars$zoomFactor, toCursor = TRUE)
    }
  }, ignoreNULL = TRUE)


  # SAVE OUTPUT
  done = function() {
    # meaning we are done with a sound - prepares the output
    # as it should be when ff are changed manually)
    if (myPars$print) print('Running done()...')
    if (!is.null(myPars$ann)) {
      if (is.null(myPars$out)) {
        myPars$out = myPars$ann
      } else {
        # remove previous records for this file, if any
        idx = which(myPars$out$file == myPars$myAudio_filename)
        if (length(idx) > 0)
          myPars$out = myPars$out[-idx, ]

        # append annotations from the current audio
        myPars$out = soundgen:::rbind_fill(myPars$out, myPars$ann)
      }
      # keep track of spectrograms to avoid analyzing them again if the user
      # goes back and forth between files
      myPars$out_spects[[myPars$myAudio_filename]] = myPars$spec
    }
    if (!is.null(myPars$out)) {
      # re-order and save a backup
      myPars$out = myPars$out[order(myPars$out$file, myPars$out$from), ]
      write.csv(myPars$out, 'www/temp.csv', row.names = FALSE)
    }
  }

  observeEvent(input$fileList, {
    done()
    myPars$n = which(myPars$fileList$name == input$fileList)
    reset()
    if (length(myPars$n) == 1 && myPars$n > 0) readAudio(myPars$n)
  }, ignoreInit = TRUE)

  nextFile = function() {
    if (!is.null(myPars$myAudio_path)) {
      done()
      if (myPars$n < myPars$nFiles) {
        myPars$n = myPars$n + 1
        updateSelectInput(session, 'fileList',
                          selected = myPars$fileList$name[myPars$n])
        # ...which triggers observeEvent(input$fileList)
      }
    }

  }
  observeEvent(input$nextFile, nextFile())

  lastFile = function() {
    if (!is.null(myPars$myAudio_path)) {
      done()
      if (myPars$n > 1) {
        myPars$n = myPars$n - 1
        updateSelectInput(session, 'fileList',
                          selected = myPars$fileList$name[myPars$n])
      }
    }
  }
  observeEvent(input$lastFile, lastFile())

  output$saveRes = downloadHandler(
    filename = function() 'output.csv',
    content = function(filename) {
      done()  # finalize the last file
      write.csv(myPars$out, filename, row.names = FALSE)
      if (file.exists('www/temp.csv')) file.remove('www/temp.csv')
    }
  )

  observeEvent(input$about, {
    if (myPars$debugQn) {
      browser()  # back door for debugging)
    } else {
      showNotification(
        ui = paste0(
          "App for annotating audio: soundgen ",
          packageVersion('soundgen'), ". Select an area of the spectrogram and ",
          "double-click or press A to add an annotation"),
        duration = 20,
        closeButton = TRUE,
        type = 'default'
      )
    }
  })

  ### TOOLTIPS - have to be here instead of UI b/c otherwise problems with regulating delay
  # (see https://stackoverflow.com/questions/47477237/delaying-and-expiring-a-shinybsbstooltip)

  shinyBS::addTooltip(session, id='reset_to_def', title = 'Reset all settings to default values', placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS::addTooltip(session, id='audioMethod', title = "Play audio with javascript (recommended in Firefox, doesn't work in Chrome) or with R (browser-independent, but then the cursor doesn't move, and you can't stop playback)", placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))

  # spectrogram
  shinyBS::addTooltip(session, id='spec_ylim', title = "Range of displayed frequencies, kHz", placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS::addTooltip(session, id='windowLength', title = 'Length of STFT window, ms.', placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS::addTooltip(session, id='step', title = 'Step between analysis frames, ms', placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS::addTooltip(session, id='specType', title = 'Spectrogram type, argument "specType" in spectrogram()', placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  # shinyBS::addTooltip(session, id='overlap', title = 'Overlap between analysis frames, %', placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS::addTooltip(session, id='dynamicRange', title = 'Dynamic range, dB', placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS::addTooltip(session, id='spec_cex', title = "Magnification coefficient controlling the size of points showing pitch candidates", placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS::addTooltip(session, id='spec_yScale', title = 'Frequency scale', placement="below", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS::addTooltip(session, id='specContrast', title = 'Regulates the contrast of the spectrogram', placement="below", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS::addTooltip(session, id='specBrightness', title = 'Regulates the brightness of the spectrogram', placement="below", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS::addTooltip(session, id='blur_freq', title = 'Gaussian filter of frequency: >0 = blur, <0 = unblur (sharpen)', placement="below", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS::addTooltip(session, id='blur_time', title = 'Gaussian filter of time: >0 = blur, <0 = unblur (sharpen)', placement="below", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS::addTooltip(session, id='zp', title = 'Zero padding: 8 means 2^8 = 256, etc.', placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS::addTooltip(session, id='wn', title = 'Type of STFT window', placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS::addTooltip(session, id='spec_maxPoints', title = 'The number of points to plot in the spectrogram (smaller = faster, but low resolution)', placement="below", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))

  # oscillogram
  shinyBS::addTooltip(session, id='osc', title = 'The type of oscillogram to show', placement="below", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS::addTooltip(session, id='osc_maxPoints', title = 'The number of points to plot in the oscillogram (smaller = faster, but low resolution)', placement="below", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))

  # action buttons
  shinyBS:::addTooltip(session, id='lastFile', title='Save and return to the previous file (PageUp)', placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS:::addTooltip(session, id='nextFile', title='Save and proceed to the next file (PageDown)', placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS:::addTooltip(session, id='selection_stop', title='Stop playback', placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS:::addTooltip(session, id='selection_play', title='Play selection (SPACEBAR)', placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS:::addTooltip(session, id='selection_annotate', title='Create a new annotation (A or DOUBLE-CLICK)', placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS:::addTooltip(session, id='selection_delete', title='Remove annotation (DELETE / BACKSPACE)', placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS::addTooltip(session, id='saveRes', title = 'Download results (see ?pitch_app for recovering unsaved data after a crash)', placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))

  # navigation / zoom
  shinyBS::addTooltip(session, id='zoomIn_freq', title = 'Zoom in frequency (+)', placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS::addTooltip(session, id='zoomOut_freq', title = 'Zoom out frequency (-)', placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS::addTooltip(session, id='scrollLeft', title = 'Scroll left (arrow LEFT)', placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS::addTooltip(session, id='zoomOut', title = 'Zoom out time (arrow DOWN)', placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS::addTooltip(session, id='zoomToSel', title = 'Zoom to selection (S)', placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS::addTooltip(session, id='zoomIn', title = 'Zoom in time (arrow UP)', placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
  shinyBS::addTooltip(session, id='scrollRight', title = 'Scroll right (arrow RIGHT)', placement="right", trigger="hover", options = list(delay = list(show = 1000, hide = 0)))
}
