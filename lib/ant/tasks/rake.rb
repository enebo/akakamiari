require 'rubygems'
require 'rake'

class RakeWrapper
  def execute(filename, *tasks)
    application = Rake.application
    application.init
    application.instance_variable_set('@rakefile', filename)
    Dir.chdir(File.dirname(filename))
    load File.expand_path(filename)
    top_level_tasks = application.top_level_tasks
    top_level_tasks.clear unless tasks.empty?
    tasks.each { |task| top_level_tasks << task }
    puts "TASKS = #{top_level_tasks}"
    application.top_level
  end
end