require 'rubygems'
require 'rake'

class RakeWrapper
  def execute(*args)
    application = Rake.application
    ARGV.clear
    args.each {|a| ARGV << a }
    application.run
  end
end
