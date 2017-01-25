#!/usr/bin/env ruby

require 'net/ssh'
require 'net/scp'
require 'json'

DEFAULT_UPLOAD_DIR = '_files'
DEFAULT_EXE_FILE = '_exe.json'

HOST = ARGV[0]
USER = ARGV[1]
KEY = ARGV[2]

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

raise 'Host not reachable' unless ping HOST

# Upload deploy files
Net::SCP.start(HOST, USER, :password => KEY, :keys => [ KEY ]) do |scp|
  upload_dir scp, DEFAULT_UPLOAD_DIR
end if File.exist? DEFAULT_UPLOAD_DIR

# Execute commands
Net::SSH.start(HOST, USER, :password => KEY, :keys => [ KEY ]) do |ssh|
  serialized = File.read(DEFAULT_EXE_FILE)
  data = JSON.parse(serialized)
  data['commands'].each do |cmd|
    exe ssh, cmd
  end
end if File.exist? DEFAULT_EXE_FILE
