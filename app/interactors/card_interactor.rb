class CardInteractor
  attr_reader :card_repository

  class InvalidUserError < StandardError; end
  class InvalidNameError < StandardError; end

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
end
