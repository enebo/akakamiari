def ant_task(*args, &block)
  @ant ||= Ant.new
  task(*args) do |rake_task|
    @ant.add_target(rake_task.name, &block)
    @ant.execute_target(rake_task.name)
  end
end
