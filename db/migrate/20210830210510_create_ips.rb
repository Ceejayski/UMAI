class CreateIps < ActiveRecord::Migration[6.1]
  def change
    create_table :ips do |t|
      t.string :ip_address
      t.references :post, null: false, foreign_key: true
      t.string :login

      t.timestamps
    end
  end
end
