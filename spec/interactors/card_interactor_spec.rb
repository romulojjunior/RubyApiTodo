require "rails_helper"

describe CardInteractor do
  let(:user) { build :user }
  let(:card) { build(:card) }
  let(:task_01) { build :task, name: "task_01" }
  let(:task_02) { build :task, name: "task_02" }
  let(:tasks) { [task_01, task_02] }
  let(:card_repository) { instance_spy CardRepository }
  let(:card_interactor) { described_class.new(card_repository: card_repository) }

  describe "#create" do
    before do
      allow(card_repository).to receive(:create).with(user, card.name).and_return(card)
      allow(card_repository).to receive(:add_tasks).with(card, tasks).and_return(true)
    end

    subject { card_interactor.create(user, card.name, tasks: tasks) }

    it { is_expected.to eq card }

    it "tasks was added" do
      subject
      expect(card_repository).to have_received(:add_tasks).with(card, tasks).once
    end

    context "when user is invalid" do
      let(:invalid_user) { nil }

      before do
        allow(card_repository).to receive(:create)
          .with(invalid_user, card.name)
          .and_raise(CardInteractor::InvalidNameError)
      end

      subject { card_interactor.create(invalid_user, card.name, tasks: tasks) }

      it "raise a CardInteractor::InvalidUserError" do
        expect { subject }.to raise_error(CardInteractor::InvalidUserError)
      end
    end

    context "when card name is invalid" do
      let(:invalid_card_name) { "" }

      before do
        allow(card_repository).to receive(:create)
          .with(user, invalid_card_name)
          .and_raise(CardInteractor::InvalidNameError)
      end

      subject { card_interactor.create(user, invalid_card_name, tasks: tasks) }

      it "raise a CardInteractor::InvalidNameError" do
        expect { subject }.to raise_error(CardInteractor::InvalidNameError)
      end
    end
  end

  describe "find_by_user_and_card_id" do
    before do
      allow(card_repository).to receive(:find_by_user_and_card_id)
        .with(user, card.id).and_return(card)
    end

    subject { card_interactor.find_by_user_and_card_id(user, card.id) }

    it do
      is_expected.to eq card
    end

    it "card was found" do
      subject
      expect(card_repository).to have_received(:find_by_user_and_card_id).with(user, card.id)
    end

    context "when card not found" do
      let(:invalid_card_id) { 1 }
      before do
        allow(card_repository).to receive(:find_by_user_and_card_id).and_return(nil)
      end

      subject { card_interactor.find_by_user_and_card_id(user, invalid_card_id) }

      it "raise a CardInteractor:CardNotFound" do
        expect { subject }.to raise_error(CardInteractor::CardNotFound)
      end
    end

    context "when user is invalid" do
      let(:invalid_user) { nil }

      subject { card_interactor.find_by_user_and_card_id(invalid_user, card.id) }

      it "raise a  InvalidUserError" do
        expect { subject }.to raise_error(CardInteractor::InvalidUserError)
      end
    end
  end
end
