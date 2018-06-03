module Api::V1
  class ChoreTaskSerializer
    include FastJsonapi::ObjectSerializer
    attributes :id, :name
  end
end
