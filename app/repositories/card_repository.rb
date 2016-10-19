class CardRepository

  def add_tasks(card, tasks)
    raise NoTasks if tasks.empty?

    card.tasks = tasks
    card.save
  end

  def create(user, name)
    Card.create(name: name, user: user)
  end

  def find_by_id(id)
    Card.find(id)
  end

  def find_by_user(user)
    Card.where(user: user)
  end

  def find_by_user_and_card_id(user, card_id)
    Card.where(id: card_id, user_id: user.id).limit(1).first
  end

  def remove_from_user_and_card_id(user, card_id)
    card = Card.where(id: card_id, user_id: user.id).limit(1).first
    card.destroy if card
    card
  end
end
