class CardRepository

  def create(user, name)
    Card.create(name: name, user: user)
  end

  def add_tasks(card, tasks)
    raise NoTasks if tasks.empty?

    card.tasks = tasks
    card.save
  end

  def find_by_user(user)
    Card.where(user: user)
  end
end
