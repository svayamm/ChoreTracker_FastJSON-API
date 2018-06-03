module Api::V1
  class ChoreSerializer
    include FastJsonapi::ObjectSerializer

    attributes :child_id, :due_on
    # belongs_to :child
    # belongs_to :task

    attribute :completed do |object|
      object.status
    end
    attribute :task do |object|
      ChoreTaskSerializer.new(object.task).serializable_hash
    end
  end
end
