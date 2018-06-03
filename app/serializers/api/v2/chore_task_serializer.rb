module Api::V2
  class ChoreTaskSerializer
    include FastJsonapi::ObjectSerializer
    attributes :id, :name
  end
end
