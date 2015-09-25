require "rails_helper"

describe Insamling do
  before(:all) do 
    stub_geocoding
  end

  it { should validate_presence_of(:about) }
  it { should validate_presence_of(:user_email) }

  describe "with invalid email" do
    it "rejects email without domain" do
      expect_email_to_fail_validation "this@is"
    end

    it "rejects email without @" do
      expect_email_to_fail_validation "this.is.com"
    end

    it "rejects email without anything before @" do
      expect_email_to_fail_validation "@is.com"
    end

    def expect_email_to_fail_validation(email)
      insamling = build(:insamling, user_email: email)

      expect(insamling.valid?).to be false
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
