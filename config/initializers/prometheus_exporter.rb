require 'prometheus_exporter/middleware'
require 'prometheus_exporter/instrumentation'
require 'prometheus_exporter/server'

Rails.application.middleware.unshift PrometheusExporter::Middleware

PrometheusExporter::Instrumentation::Process.start(type: 'web')

Thread.new do
  server = PrometheusExporter::Server::WebServer.new(bind: '0.0.0.0', port: 9394)
  server.start
end

