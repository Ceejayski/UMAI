class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    create_table :users, id: :uuid do |t|
      t.string :login
      t.string :password_digest

      t.timestamps
    end
  end
end
