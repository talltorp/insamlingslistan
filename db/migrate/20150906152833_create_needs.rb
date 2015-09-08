class CreateNeeds < ActiveRecord::Migration
  def change
    create_table :needs do |t|
      t.string :title
      t.string :description
      t.references :insamling, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
