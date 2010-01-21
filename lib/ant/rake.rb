def ant_task(*args, &block)
  @ant ||= Ant.new
  task = task(*args, &block)
  @ant.add_target task
  @ant.execute_target task.name
end
