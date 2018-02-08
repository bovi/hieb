#!/usr/bin/env ruby

require 'net/ssh'
require 'net/scp'
require 'json'

DEFAULT_UPLOAD_DIR = '_files'
DEFAULT_EXE_FILE = '_exe.json'

def ping ip
  begin
    r = `ping -c 1 -t1 -W1 #{ip} |grep packets`
    r.match(/transmitted, (.*?) packets/)[1].to_i == 1
  rescue
    false
  end
end

def exe(ssh, cmd)
  puts "# #{cmd}"
  ssh.exec!(cmd) do |channel, stream, data|
    puts "#{data}"
  end
end

def upload(scp, file)
  puts ">> UPLOAD: /#{file}"
  scp.upload! "_files/#{file}", "/#{file}"
end

def upload_dir(scp, dir)
  Dir.foreach dir do |f1|
    next if f1 =~ /^\.|\..$/
    f2 = File.join(dir, f1)
    if File.directory? f2
      upload_dir scp, f2
    else
      upload scp, f2.sub!(/^#{DEFAULT_UPLOAD_DIR}\//, '')
    end
  end
end

def upload_files(host, user, key, upload_dir)
  # Upload deploy files
  Net::SCP.start(host, user, :password => key, :keys => [ key ]) do |scp|
    upload_dir scp, upload_dir
  end if File.exist? upload_dir
end

def execute_commands(host, user, key, exe_file, options = {})
  if options[:paranoid] == true
    paranoid = true
  else
    paranoid = false
  end
  # Execute commands
  Net::SSH.start(host, user, :password => key, :keys => [ key ], :verify_host_key => paranoid) do |ssh|
    serialized = File.read(exe_file)
    data = JSON.parse(serialized)
    data['commands'].each do |cmd|
      exe ssh, cmd
    end
  end if File.exist? exe_file
end

