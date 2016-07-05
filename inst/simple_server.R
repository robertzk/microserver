library(methods)
devtools::load_all()

routes <- source(microserver:::packagefile('routes.R'))$value
cat('listening..\n')
microserver::run_server(routes, 33399)
