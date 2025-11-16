class UserCreateSerializer < ActiveModel::Serializer
  attributes :email, :balance, :token

  def email
    object.user.email
  end

  def balance
    object.user.balance.to_f
  end

  def token
    object.token
  end
end
