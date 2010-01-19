require 'rubygems'
require 'rake'

class RakeWrapper
  def load_tasks(*args)
    # FIXME: Use our arguments (this sucks...let's submit a patch for Rake
    ARGV.clear
    ARGV.concat args

    Rake.application.tap do |application|
      application.init
      application.load_rakefile
    end
  end

  def execute(*args)
    load_tasks(*args).top_level
  end

  def invoke_task(task)
    Rake.application[task].invoke
  end

  def import(*args)
    application = load_tasks(*args)
    application
  end
end
