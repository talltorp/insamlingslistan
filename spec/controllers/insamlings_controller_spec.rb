require "rails_helper"

describe InsamlingsController do
  before(:all) do 
    stub_geocoding
  end

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

    context "when a user is logged in" do
      it "assigns the logged in user to 'current_user'" do
        insamling = create(:insamling)
        log_in_with(insamling.user_email)
        params = {
          id: insamling.id
        }

        get :show, params

        expect(assigns(:current_user)).not_to be_nil
      end

      def log_in_with(email)
        session[:current_user] = email
      end
    end
  end

  describe "#create" do

    it "creates a new Insamling" do
      params = {
        insamling: {
          about: "about insamling",
          description: "description insamling",
          user_email: "good@person.com",
          location: "gatan 1 12345 stan",
        }
      }

      post :create, params
      insamling = Insamling.last

      expect(insamling.admin_token).to be_a String
      expect(insamling.about).to be_a String
      expect(insamling.description).to be_a String
      expect(insamling.location).to be_a String
      expect(insamling.latitude).to be_a Float
      expect(insamling.longitude).to be_a Float
    end

    it "redirects to the :show action" do
      params = {
        insamling: {
          about: "about insamling",
          description: "description insamling",
          user_email: "good@person.com",
          location: "gatan 1 12345 stan",
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
          location: "gatan 1 12345 stan",
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
          location: "gatan 1 12345 stan",
        }
      }

      post :create, params

      mail = ActionMailer::Base.deliveries.last
      expect(mail.from.first).to eql("info@insamlingslistan.se")
      expect(mail.to.first).to eql("good@person.com")
    end

    context "with invalid parameters" do
      it "renders the 'new' template" do
        params = {
          insamling: {
            user_email: "bademail",
          }
        }

        post :create, params

        expect(response).to render_template(:new)
        expect(assigns(:insamling)).to be_a(Insamling)
      end
    end
  end

  def stub_geocoding
    Geocoder.configure(:lookup => :test)

    Geocoder::Lookup::Test.set_default_stub([
      {
        'latitude'     => 40.7143528,
        'longitude'    => -74.0059731,
        'address'      => 'gatan 1',
        'country'      => 'stan',
        'country_code' => 'SE'
      }
     ]
    )
  end
end
