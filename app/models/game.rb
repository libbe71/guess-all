class Game < ApplicationRecord
  belongs_to :player1, class_name: "User"
  belongs_to :player2, class_name: "User"
  belongs_to :winner, class_name: "User", optional: true
  belongs_to :round, class_name: "User" # Adjust if 'round' refers to a different model
  has_many :moves, -> { order(:position) }, dependent: :destroy

  validates :player1, :player2, presence: true
  validates :status, inclusion: { in: ["started", "finished"] }
  
end