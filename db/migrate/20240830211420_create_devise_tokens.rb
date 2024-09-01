class CreateDeviseTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :devise_tokens do |t|
      t.string :devise_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
