class Insamling < ActiveRecord::Base
  has_many :needs
  validates_presence_of [:about, :user_email]
  validates_format_of :user_email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create

  before_create :generate_admin_token
  geocoded_by :location
  after_validation :geocode, if: ->(obj){ location.present? and location_changed? }

  private

  def generate_admin_token
    self.admin_token = SecureRandom.hex(10)
  end
end
