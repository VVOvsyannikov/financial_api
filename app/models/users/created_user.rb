module Users
  class CreatedUser
    include ActiveModel::Model
    include ActiveModel::Serialization

    attr_accessor :user, :token

    def self.model_name
      ActiveModel::Name.new(User)
    end
  end
end
