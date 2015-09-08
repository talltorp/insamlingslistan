class Insamling < ActiveRecord::Base
  has_many :needs

  before_create :generate_admin_token

  private

  def generate_admin_token
    self.admin_token = SecureRandom.hex(10)
  end
end
