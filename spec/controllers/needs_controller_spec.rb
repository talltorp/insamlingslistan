require 'rails_helper'

describe NeedsController do

  describe "#create" do
    context "with valid params" do
      it "created a new Need on the Insamling" do
        insamling = create(:insamling)
        params = {
          insamling_id: insamling.id,
          need: {
            title: "this is needed",
            description: "And a descition"
          }
        }

        expect { post :create, params }.to change { Need.count }.by(1)
        insamling.reload
        expect(insamling.needs.length).to eql(1)
      end

      it "redirects to the admin page" do
        insamling = create(:insamling)
        params = {
          insamling_id: insamling.id,
          need: {
            title: "this is needed",
            description: "And a descition"
          }
        }

        post :create, params

        expect(response).to redirect_to "/insamlings/#{ insamling.id }/admins/#{ insamling.admin_token }"
      end
    end
  end

  describe "#destroy" do
    it "deletes the need" do
      insamling = create_insamling_with_one_need
      params = {
        insamling_id: insamling.id,
        id: insamling.needs.first.id
      }

      expect { delete :destroy, params }.
        to change { Need.count }.from(1).to(0)
    end

    it "removes the need from the insamling" do
      insamling = create_insamling_with_one_need
      params = {
        insamling_id: insamling.id,
        id: insamling.needs.first.id
      }

      expect { delete :destroy, params }.
        to change { Need.count }.from(1).to(0)
    end

    it "redirects to the admin page" do
      insamling = create_insamling_with_one_need
      params = {
        insamling_id: insamling.id,
        id: insamling.needs.first.id
      }

      delete :destroy, params

      expect(response).to redirect_to "/insamlings/#{ insamling.id }/admins/#{ insamling.admin_token }"
    end

    def create_insamling_with_one_need
      insamling = build(:insamling)
      insamling.needs << build(:need)
      insamling.save!
      insamling
    end
  end
end
