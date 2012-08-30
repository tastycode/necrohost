require 'fileutils'

pid_path = "/data/necrohost/current/tmp/pids"
FileUtils.mkdir_p pid_path unless File.exists? pid_path
pid File.join(pid_path, "unicorn.pid")

worker_processes 8
working_directory "/data/necrohost/current"
listen 'unix:/tmp/necrohost.sock', :backlog => 512
timeout 120

preload_app true

if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

