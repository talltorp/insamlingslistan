require "rails_helper"

describe InsamlingsController do
  describe "#show" do
    it "renders the :show template" do
      insamling = create(:insamling)
      params = {
        id: insamling.id
      }

      get :show, params

      expect(response.status).to eq(200)
      expect(response).to render_template("show")
    end

    it "assigns an Insamling to insamling" do
      insamling = create(:insamling)
      params = {
        id: insamling.id
      }

      get :show, params

      expect(assigns(:insamling)).to be_a Insamling
    end
  end

  describe "#create" do
    it "creates a new Insamling" do
      params = {
        insamling: {
          about: "about insamling",
          description: "description insamling",
          user_email: "good@person.com",
        }
      }

      post :create, params
      insamling = Insamling.last

      expect(insamling.admin_token).to be_a String
    end

    it "redirects to the :show action" do
      params = {
        insamling: {
          about: "about insamling",
          description: "description insamling",
          user_email: "good@person.com",
        }
      }

      post :create, params
      insamling = Insamling.last

      expect(response).to redirect_to("/insamlings/#{ insamling.id }")
    end

    it "informs the user of successful creation" do
      params = {
        insamling: {
          about: "about insamling",
          description: "description insamling",
          user_email: "good@person.com",
        }
      }

      post :create, params
      insamling = Insamling.last

      expect(flash[:notice]).to match(/skapad/)

    end

    it "sends an email to the creator" do
      params = {
        insamling: {
          about: "about insamling",
          description: "description insamling",
          user_email: "good@person.com",
        }
      }

      post :create, params

      mail = ActionMailer::Base.deliveries.last
      expect(mail.from.first).to eql("info@insamlingslistan.se")
      expect(mail.to.first).to eql("good@person.com")
    end
  end
end
