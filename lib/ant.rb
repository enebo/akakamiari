require 'java'

# Hacked for now.  Must replace with auto-discovery with simple explicit set
# option.

# ant-launcher.jar is required because we use Project.init()
file = File.join(ENV['ANT_HOME'], 'lib') if ENV['ANT_HOME']
file = '/Uers/enebo/work/apache-ant-1.7.1/build/lib/' unless file
$CLASSPATH << File.join(file, 'ant.jar') << File.join(file, 'ant-launcher.jar')

require 'ant/ant'
