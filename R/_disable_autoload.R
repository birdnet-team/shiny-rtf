# Disabling shiny autoload

# See ?shiny::loadSupport for more information
golem::create_golem("testAutoload")`

# as a dummy example, use the NAMESPACE-imported favicon to define an object
write("fav_icon <- favicon()", "R/break_autoload.R")
golem::add_rstudioconnect_file()
shiny::runApp()
# => could not find function "favicon"
