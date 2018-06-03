module Api::V2
  class ChoreSerializer
    include FastJsonapi::ObjectSerializer

    attributes :due_on
    # belongs_to :child
    # belongs_to :task

    attribute :completed do |object|
      object.status
    end

    attribute :task do |object|
      ChoreTaskSerializer.new(object.task).serializable_hash
    end
    attribute :child do |object|
      ChoreChildSerializer.new(object.child).serializable_hash
    end
  end
end
