LIB_DIR = File.join File.dirname(__FILE__), 'lib'
$LOAD_PATH << LIB_DIR

require 'rake/clean'
require 'ant'

JAVA_CLASSES_DIR = 'build/classes'

CLEAN.include '**/*~', 'samples/java_build/*', 'build/*'

task :default => :compile do
  puts "default_task executing"
end

task :compile => :setup do
  puts "compile_task executing"
  ant.javac :srcdir => 'src', :destdir => JAVA_CLASSES_DIR do
    classpath do
      pathelement :location => File.join(Ant::ANT_HOME, 'lib', 'ant.jar')
      pathelement :location => File.join(LIB_DIR, 'jruby-complete.jar')
    end
  end
end

task :setup do
  puts "setup_task_executing"
  mkdir_p JAVA_CLASSES_DIR
end
