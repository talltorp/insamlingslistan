require 'rails_helper'

describe AdminsController do
  describe "#show" do
    context "with a valid authentication token" do
      it "renders the admin interface" do
        insamling = create(:insamling)
        params = {
          insamling_id: insamling.id,
          id: insamling.admin_token
        }

        get :show, params

        expect(response.code).to eql("200")
        expect(response).to render_template(:show)
      end
    end

    context "with an invalid authentication token" do
      it "redirects to the insamling" do
        insamling = create(:insamling)
        params = {
          insamling_id: insamling.id,
          id: "invalid_id"
        }

        get :show, params

        expect(response).to redirect_to("/insamlings/#{ insamling.id }")
      end
    end
  end
end
