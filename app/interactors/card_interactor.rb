class CardInteractor
  attr_reader :card_repository

  class InvalidUserError < StandardError; end
  class InvalidNameError < StandardError; end
  class CardNotFound < StandardError; end

  def initialize(card_repository: CardRepository.new)
    @card_repository = card_repository
  end

  def create(user, name, tasks: [])
    raise InvalidUserError.new "Invalid user" if user.nil? || !user.is_a?(User)
    raise InvalidNameError.new "Invalid name" if name.nil? || name.empty?

    card = card_repository.create(user, name)
    unless tasks.empty?
      card_repository.add_tasks(card, tasks)
    end
    card
  end

  def find_by_user_and_card_id(user, card_id)
    raise InvalidUserError.new "Invalid user" if user.nil? || !user.is_a?(User)

    card = card_repository.find_by_user_and_card_id(user, card_id)
    raise CardNotFound.new "Card not found" if card.nil?
    card
  end
end
