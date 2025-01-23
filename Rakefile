require 'rake'

desc "install the dot files into user's home directory"
task :install do
  @replace_all = false
  files = Dir['*'] - %w[Rakefile README.md install.sh config tags]
  files.each do |file|
    install_file(File.join(ENV['PWD'], file), File.join(ENV['HOME'], ".#{file}"))
  end
  # special case for config files and directories to avoid clobbering local configs
  Dir['config/*'].each do |file|
    install_file(File.join(ENV['PWD'], file), File.join(ENV['HOME'], ".#{file}"))
  end
end

def install_file(source, destination)
  system %Q{mkdir -p "#{File.dirname(destination)}"}
  if File.exist?(destination)
    if File.identical?(source, destination)
      puts "identical #{output_filepath(destination)}"
    elsif @replace_all
      replace_file(source, destination)
    else
      print "overwrite #{output_filepath(destination)}? [ynaq] "
      case $stdin.gets.chomp
      when 'a'
        @replace_all = true
        replace_file(source, destination)
      when 'y'
        replace_file(source, destination)
      when 'q'
        exit
      else
        puts "skipping #{output_filepath(destination)}"
      end
    end
  else
    link_file(source, destination)
  end
end

def replace_file(source, destination)
  system %Q{rm -rf "#{destination}"}
  link_file(source, destination)
end

def link_file(source, destination)
  puts "linking #{output_filepath(destination)}"
  system %Q{ln -s "#{source}" "#{destination}"}
end

def output_filepath(path)
  path.to_s.sub(/^#{ENV['HOME']}/, "~")
end
