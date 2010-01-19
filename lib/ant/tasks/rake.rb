require 'rubygems'
require 'rake'

class RakeWrapper
  def load_tasks(*args)
    application = Rake::Application.new
    Rake.application = application
    ARGV.clear
    args.each {|a| ARGV << a }
    application.init
    application.load_rakefile
    application
  end

  def execute(*args)
    application = load_tasks(*args)
    application.top_level
  end

  def invoke_task(task)
    application = load_tasks
    application[task].invoke
  end
end
