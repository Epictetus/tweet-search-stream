#!/usr/bin/env ruby
# coding: utf-8

# Copyright: Hiroshi Ichikawa <http://gimite.net/en/>
# License: New BSD License

$KCODE = "u"
$LOAD_PATH << "."
$LOAD_PATH << "./lib"
Thread.abort_on_exception = true

require "logger"
require "fileutils"

require "rubygems"
require "daemons"

require "tss_web_server"
require "tss_web_socket_server"


#WebSocket.debug = true
root_dir = File.dirname(File.expand_path(__FILE__))

opts = {
  :log_output => true,
  :dir_mode => :normal,
  :dir => "log",
  :monitor => true,
}
Daemons.run_proc("tss_server", opts) do
  FileUtils.cd(root_dir)
  Session.start_auto_save()
  server = TSSWebSocketServer.new()
  Thread.new(){ server.run() }
  TSSWebServer.run!()
end
