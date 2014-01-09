class CreateVarifyCodes < ActiveRecord::Migration
  def change
    create_table :varify_codes do |t|
      t.integer :code
      t.integer :user_id
      t.boolean :has_validate

      t.timestamps
    end
  end
end
