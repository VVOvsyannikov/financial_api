class UserSerializer < ActiveModel::Serializer
  attributes :email, :balance

  def balance
    object.balance.to_f
  end
end
