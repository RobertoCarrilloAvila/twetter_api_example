class Users < ActiveRecord::Migration
	def change
		create_table :users do |t|
			t.string :name
			t.string :token
			t.string :token_secret

			t.timestamps null: false
		end


		create_table :twetts do |t|
			t.belongs_to :user, index:true
			t.text :description

			t.timestamps null: false
		end
	end
end
