class Club < ActiveRecord::Base
  attr_accessible :title

  validates :title, :creator, presence: true

  belongs_to(
    :creator,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id
  )

  has_many(
    :posts,
    class_name: "Post",
    foreign_key: :club_id,
    primary_key: :id
  )


end
