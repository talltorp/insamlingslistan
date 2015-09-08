class CreateInsamlings < ActiveRecord::Migration
  def change
    create_table :insamlings do |t|
      t.string :about
      t.string :description
      t.string :user_email
      t.string :admin_token

      t.timestamps null: false
    end
  end
end
