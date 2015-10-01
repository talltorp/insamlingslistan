class AddWhenToInsamling < ActiveRecord::Migration
  def change
    add_column :insamlings, :when, :string
  end
end
