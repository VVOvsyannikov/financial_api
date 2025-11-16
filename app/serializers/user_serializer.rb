class UserSerializer
  include JSONAPI::Serializer

  attributes :email

  attribute :balance do |user|
    user.balance.to_f
  end

  attribute :token, if: Proc.new { |user, params|
      params && params[:token].present?
    } do |_user, params|
    params[:token]
  end
end
