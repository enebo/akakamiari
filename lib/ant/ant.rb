require 'java'
require 'ant/element'
require 'ant/target'

java_import org.apache.tools.ant.ComponentHelper
java_import org.apache.tools.ant.DefaultLogger
java_import org.apache.tools.ant.Project
java_import org.apache.tools.ant.Target

class Ant
  attr_reader :project

  def initialize(options={}, &block)
    @options = options
    @project = create_project options
    initialize_elements
  end

  def create_project(options)
    # If we are calling into a rakefile from ant then we already have a project to use
    return $project if $project

    Project.new.tap do |p|
      p.init
      p.add_build_listener(DefaultLogger.new.tap do |log|
        log.output_print_stream = java.lang.System.out
        log.error_print_stream = java.lang.System.err
        log.emacs_mode = true
        log.message_output_level = options[:output_level] || 2
      end)
    end
  end

  # Add a target (two forms)
  # 1. Execute a block as a target: add_target "foo-target" { echo :message => "I am cool" }
  # 2. Execute a rake task as a target: add_target Rake.application["default"]
  def add_target(task, &block)
    target = block_given? ? BlockTarget.new(self, task, &block) : RakeTarget.new(self, task)
    @project.add_target target
  end

  def execute_target(name)
    @project.execute_target(name)
  end

  # We generate top-level methods for all default data types and task definitions for this instance
  # of ant.  This eliminates the need to rely on method_missing.
  def initialize_elements
    @elements = {}
    @helper = ComponentHelper.get_component_helper @project
    generate_children @project.data_type_definitions
    generate_children @project.task_definitions
  end

  # All elements (including nested elements) are registered so we can access them easily.
  def acquire_element(name, clazz)
    element = @elements[name]
    return element if element

    # Not registered in ant's type registry for this project (nested el?)
    unless @helper.get_definition(name)
      @project.log "Adding #{name} -> #{clazz.inspect}", 5
      @helper.add_data_type_definition(name, clazz)
    end

    @elements[name] = :give_it_something_to_prevent_endless_recursive_defs
    @elements[name] = Element.new(self, name, clazz)
  end

  def generate_children(collection)
    collection.each do |name, clazz|
      element = acquire_element(name, clazz)
      self.class.send(:define_method, name) do |*a, &b|
        element.call(@current_target, *a, &b)
      end
    end
  end

  class << self
    def ant(options={}, &code)
      @ant ||= Ant.new options
      code.arity==1 ? code[@ant] : @ant.instance_eval(&code) if block_given?
      @ant
    end
  end
end

def ant(*args, &block)
  Ant.ant(*args, &block)
end

def ant_import(filename = 'build.xml')
  # FIXME: Implement this
end
