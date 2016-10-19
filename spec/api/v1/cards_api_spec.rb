require "rails_helper"

describe API::V1::CardsAPI do
  let(:user) { build :user }
  let(:card) { build :card, user: user }
  let(:card_interactor) { instance_spy CardInteractor }
  let(:card_repository) { instance_spy CardRepository }

  before do
    Grape::Endpoint::before_each do |endpoint|
      allow(endpoint).to receive(:card_interactor).and_return(card_interactor)
      allow(endpoint).to receive(:card_repository).and_return(card_repository)
      allow(endpoint).to receive(:validate_api_key).and_return(user)
      allow(endpoint).to receive(:current_user).and_return(user)
    end
  end

  after { Grape::Endpoint.before_each(nil) }

  endpoint "GET /api/v1/cards" do
    let(:make_request) { get path }

    describe "response body" do
      before do
        allow(card_repository).to receive(:find_by_user).with(user).and_return([card])
      end

      subject { response.body }

      it do
        make_request
        expect(subject).to include_json([{name: card.name, status: card.status}])
      end
    end
  end

  endpoint "POST /api/v1/cards" do
    let(:task_01) { build :task, name: "task_01", description: nil  }
    let(:tasks) { [ { name: task_01.name } ] }
    let(:params) { { name: card.name, tasks: tasks } }
    let(:make_request) { post path, params: params }

    describe "response body" do
      before do
        allow(card_interactor).to receive(:create).and_return(card)
      end

      subject { response.body }

      it do
        make_request
        expect(subject).to include_json(name: card.name, status: card.status)
      end
    end
  end

  endpoint "GET /api/v1/cards/:id" do
    let(:card) { build :card, id: 1 }
    let(:make_request) { get "/api/v1/cards/#{card.id}" }

    describe "response body" do
      before do
        allow(card_interactor).to receive(:find_by_user_and_card_id).and_return(card)
      end

      subject { response.body }

      it do
        make_request
        expect(subject).to include_json(name: card.name, status: card.status)
      end

      context "when card not found" do
        before do
          allow(card_interactor).to receive(:find_by_user_and_card_id)
            .and_raise(CardInteractor::CardNotFound)
        end

        subject { response.body }

        it do
          make_request
          expect(subject).to include_json(error:"Card not found")
        end
      end
    end
  end

  endpoint "DELETE /api/v1/cards/:id" do
    let(:card) { build :card, id: 1 }
    let(:make_request) { delete "/api/v1/cards/#{card.id}" }

    describe "response body" do
      before do
        allow(card_interactor).to receive(:remove_from_user_and_card_id).and_return(card)
      end

      subject { response.body }

      it do
        make_request
        expect(subject).to include_json(name: card.name, status: card.status)
      end

      context "when card not found" do
        before do
          allow(card_interactor).to receive(:remove_from_user_and_card_id)
            .and_raise(CardInteractor::CardNotFound)
        end

        subject { response.body }

        it do
          make_request
          expect(subject).to include_json(error:"Card not found")
        end
      end
    end
  end
end
