class User < ApplicationRecord
  has_secure_password

  validates :password, presence: true
  validates :name, :email, presence: true, uniqueness: true

    # Relationships
    has_many :sent_chats, class_name: 'Chat', foreign_key: 'sender_id', dependent: :destroy
    has_many :conversations_as_user1, class_name: 'Conversation', foreign_key: 'user_1_id', dependent: :destroy
    has_many :conversations_as_user2, class_name: 'Conversation', foreign_key: 'user_2_id', dependent: :destroy
end
