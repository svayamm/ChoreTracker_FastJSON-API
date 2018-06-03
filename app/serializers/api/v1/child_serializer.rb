module Api::V1
  class ChildSerializer
    include FastJsonapi::ObjectSerializer

    # has_many :chores
    # has_many :tasks, through: :chores
    attributes :name, :points_earned, :active
    attribute :completed_chores do |object|
      object.chores.done.map do |chore|
        ChoreSerializer.new(chore).serializable_hash
      end
    end

    attribute :pending_chores do |object|
      object.chores.pending.map do |chore|
        ChoreSerializer.new(chore).serializable_hash
      end
    end
  end
end
