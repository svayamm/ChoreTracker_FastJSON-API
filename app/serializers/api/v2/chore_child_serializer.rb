module Api::V2
    class ChoreChildSerializer
      include FastJsonapi::ObjectSerializer
      attributes :id, :name, :points_earned, :active
    end
  end
  