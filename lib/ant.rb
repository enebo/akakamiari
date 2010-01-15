require 'java'

def get_from_ant
  IO.popen("ant -diagnostics") do |diag| 
    home = diag.readlines.grep(/ant.home/).first.sub('ant.home: ', '').chomp
    return File.join(home, "lib") if home
  end
  nil
end

def locate_ant_home
  if ENV['ANT_HOME'] 
    home = File.join(ENV['ANT_HOME'], 'lib')
    return home if File.exist? home
  end
  get_from_ant
end

file = locate_ant_home

# ant-launcher.jar is required because we use Project.init()
$CLASSPATH << File.join(file, 'ant.jar') << File.join(file, 'ant-launcher.jar')

require 'ant/ant'
require 'ant/rake' if defined?(::Rake)
