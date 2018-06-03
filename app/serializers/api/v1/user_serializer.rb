module Api::V1
  class UserSerializer
    include FastJsonapi::ObjectSerializer
    attributes :id, :email, :api_key
  end
end
