class TaskRepository
  def find_by_id(id)
    Task.find(id)
  end

  def find_by_user_and_task_id(user, task_id)
    user.tasks.find_by_id(task_id)
  end

  def update_from_user_and_attributes(user, attributes)
    task = user.tasks.find_by_id(attributes[:id])
    return nil unless task

    attrs = validate_attrs(attributes)
    task.update_attributes(attrs)
    task
  end

  def remove_from_user_and_task_id(user, task_id)
    task = find_by_user_and_task_id(user, task_id)
    task.destroy if task
    task
  end

  private

  def validate_attrs(attributes)
    attrs = {}

    if attributes[:name].present?
      attrs[:name] = attributes[:name]
    end

    if attributes[:status].present?
      attrs[:status] = attributes[:status]
    end

    if attributes[:description].present?
      attrs[:description] = attributes[:description]
    end

    attrs
  end
end
