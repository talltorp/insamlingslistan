require 'rails_helper'

describe AdminsController do
  describe "#show" do
    before(:all) do 
      stub_geocoding
    end

    context "with a valid authentication token" do
      it "logs the user in" do
        insamling = create(:insamling)
        params = {
          insamling_id: insamling.id,
          id: insamling.admin_token
        }

        get :show, params

        expect(session[:current_user]).to eql(insamling.user_email)
        expect(response).to redirect_to("/insamlings/#{ insamling.id }")
      end
    end

    context "with an invalid authentication token" do
      it "redirects to the insamling without logging the user in" do
        insamling = create(:insamling)
        params = {
          insamling_id: insamling.id,
          id: "invalid_id"
        }

        get :show, params

        expect(session[:current_user]).to be_nil
        expect(response).to redirect_to("/insamlings/#{ insamling.id }")
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
