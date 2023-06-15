#' Plot Results of Fast Fourier Transform (FFT)
#'
#' This is a modified version of av::plot.av_fft().
#'
#' This function is used to visualize the results of an FFT, specifically to plot an object returned from av::read_audio_fft(). It provides several customization options such as color scheme,
#' the time range to plot, and whether or not to display a legend.
#'
#' @param x Object returned from av::read_audio_fft(). It should have the following attributes: "time", "frequency", "duration", "sample_rate", "input".
#' @param dark Logical. If TRUE, uses a dark theme for the plot. Default is TRUE.
#' @param legend Logical. If TRUE, adds a legend to the plot. Default is TRUE.
#' @param keep.par Logical. If FALSE, resets the graphical parameters after the function call. Default is FALSE.
#' @param useRaster Logical. Indicates whether to use a raster representation. Default is TRUE.
#' @param vline Numeric. Specifies a vertical line at a certain time. Default is NULL.
#' @param max.freq Numeric. Sets the maximum frequency to plot. If not specified, it's set to half of the "sample_rate" attribute of `x`. Default is NULL.
#' @param tstart Numeric. The time at which to start the plot. Default is 0.
#' @param tende Numeric. The time at which to end the plot. If not specified, it's set to the "duration" attribute of `x`. Default is NULL.
#' @param kHz Logical. If TRUE, display frequencies in kHz (kilohertz). Default is FALSE.
#' @param delineate_center Numeric. If set, will delineate a region around the center of the time axis. Default is NULL.
#' @param ... Other parameters passed to the underlying plot function.
#'
#' @return This function does not return a value; it is used for the side effect of creating a plot.
#'
#' @examples
#' \dontrun{
#' # You can replace this with an example of your function in action, using actual data.
#' }
#' @export
#' @noRd

plot_av_fft <-
  function(x,
           dark = TRUE,
           legend = TRUE,
           keep.par = FALSE,
           useRaster = TRUE,
           vline = NULL,
           max.freq = NULL,
           tstart = 0,
           tende = NULL,
           kHz = FALSE,
           delineate_center = NULL,
           ...) {

    # Check input: should not be NULL
    if (is.null(x)) {
      stop("Input is NULL.")
    }

    # Check attributes of x
    necessary_attributes <- c("time", "frequency", "duration", "sample_rate", "input")
    missing_attributes <- necessary_attributes[!(necessary_attributes %in% names(attributes(x)))]

    if (length(missing_attributes) > 0) {
      stop(paste("Input is missing the following necessary attributes:", paste(missing_attributes, collapse = ", "), "."))
    }

    # If 'keep.par' is FALSE, save the current graphical parameters and ensure they will be reset when the function exits
    if (!isTRUE(keep.par)) {
      oldpar <- graphics::par(no.readonly = TRUE)
      on.exit(graphics::par(oldpar))
    }

    # Set color scheme for the plot, depending on the 'dark' option
    col <- if (isTRUE(dark)) {
      graphics::par(
        bg = "black",
        col.axis = "white",
        fg = "white",
        family = "mono",
        font = 2,
        col.lab = "white",
        col.main = "white"
      )
      viridisLite::inferno(24, direction = -1)

    } else {
      gray.colors(
        24,
        start = 0,
        end = 1,
        gamma = 2.2,
        1,
        rev = FALSE
      )
    }

    # Check if 'tende' (the end time) is specified, if not, set it to the 'duration' attribute of 'x'
    if (is.null(tende)) {
      # if no end is given, print everything
      tende <- attr(x, "duration")
    }

    # Set unit and divider based on the 'kHz' option
    if (kHz) {
      unit <- "kHz"
      divider <- 1000
    } else {
      unit <- "Hz"
      divider <- 1
    }

    # Check if 'max.freq' is specified, if not, set it to half of the 'sample_rate' attribute of 'x'
    if (is.null(max.freq)) {
      # if no maximum frequency is given, print everything
      max.freq <- (attr(x, "sample_rate") / 2) / divider
    }

    # Set some graphical parameters and create an image plot using these parameters and the attributes of 'x'
    graphics::par(mar = c(5, 5, 3, 3), mex = 0.6)
    graphics::image(
      attr(x, "time"),
      attr(x, "frequency") / divider,
      t(x),
      ylim = c(0, max.freq),
      xlim = c(tstart, tende),
      xlab = "TIME",
      ylab = sprintf("FREQUENCY (%s)", unit),
      col = col,
      useRaster = useRaster,
      ...
    )
    # If 'delineate_center' is not NULL, draw two vertical dashed lines to delineate the central region of the plot
    if (!is.null(delineate_center)) {
      # calculate the center
      buffer <- (tende - tstart - delineate_center)/2

      graphics::abline(
        v = tstart + buffer,
        lwd = 1.1,
        lty = 2,
        col = "blue"
      )
      graphics::abline(
        v = tende - buffer,
        lwd = 1.1,
        lty = 2,
        col = "blue"
      )
    }

    # If 'vline' has some value(s), draw vertical line(s) at these time points
    if (length(vline)) {
      graphics::abline(v = vline, lwd = 2)
    }

    # If 'legend' is TRUE, add a legend to the plot showing the number of channels and sample rate
    if (isTRUE(legend)) {
      input <- attr(x, "input")
      label <- sprintf(
        "%d channel, %d%s",
        input$channels,
        attr(x, "sample_rate") / divider,
        unit
      )
      graphics::legend(
        "topright",
        legend = label,
        pch = "",
        xjust = 1,
        yjust = 1,
        bty = "o",
        cex = 0.7
      )
    }
  }

