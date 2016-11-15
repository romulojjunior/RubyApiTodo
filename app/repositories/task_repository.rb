class TaskRepository
  def find_by_id(id)
    Task.find(id)
  end

  def find_by_user_and_task_id(user, task_id)
    user.tasks.find_by_id(task_id)
  end

  def remove_from_user_and_task_id(user, task_id)
    task = find_by_user_and_task_id(user, task_id)
    task.destroy if task
    task
  end
end
