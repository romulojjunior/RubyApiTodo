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

  def update_from_user_and_attributes(user, attributes)
    card = user.cards.find_by_id(attributes[:id])
    return nil unless card

    attrs = validate_attrs(attributes)
    card.update_attributes(attrs)
    card
  end

  def remove_from_user_and_card_id(user, card_id)
    card = Card.where(id: card_id, user_id: user.id).limit(1).first
    card.destroy if card
    card
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

    attrs
  end
end
