class Game < ApplicationRecord
  belongs_to :player1, class_name: "User"
  belongs_to :player2, class_name: "User"

  validates :player1, :player2, presence: true
  validates :status, inclusion: { in: ["started", "finished"] }
end
