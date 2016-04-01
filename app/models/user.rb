class User < ActiveRecord::Base

	has_many :twetts

	validates :name, uniqueness: true

end
