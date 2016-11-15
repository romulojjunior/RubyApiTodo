class TaskInteractor
  attr_reader :task_repository

  class InvalidUserError < StandardError; end
  class TaskNotFound < StandardError; end

  def initialize(task_repository: TaskRepository.new)
    @task_repository = task_repository
  end

  def find_by_user_and_task_id(user, task_id)
    raise InvalidUserError.new "Invalid user" if user.nil? || !user.is_a?(User)

    task = task_repository.find_by_user_and_task_id(user, task_id)
    raise TaskNotFound.new "Task not found" if task.nil?
    task
  end

  def remove_from_user_and_task_id(user, task_id)
    raise InvalidUserError.new "Invalid user" if user.nil? || !user.is_a?(User)

    task = task_repository.remove_from_user_and_task_id(user, task_id)
    raise TaskNotFound.new "Task not found" if task.nil?
    task
  end
end
