module Api::V1
  class TaskSerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :points, :active
    # has_many :chores
    # has_many :children, through: :chores
  end
end
