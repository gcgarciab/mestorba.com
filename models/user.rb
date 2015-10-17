class User
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  # field <name>, :type => <type>, :default => <value>
  field :name, :type => String
  field :email, :type => String
  field :cellphone, :type => String
  field :uid, :type => String
  field :status, :type => Integer, default: 1
  field :access_token, :type => String

  validates_uniqueness_of :uid

  has_many :items

  def self.login(auth)
    user = User.where(uid: auth["uid"]).first
    if user
      user.uid      = auth["uid"]
      user.name    = auth["info"]["name"]
      user.access_token = auth["credentials"]["token"]
      if user.save
        user
      else
        false
      end
    else
      false
    end
  end

  def self.create_with_omniauth(auth)
    puts auth.inspect
    create! do |user|
      user.uid      = auth["uid"]
      user.name    = auth["info"]["name"]
      user.email    = auth["user_info"]["email"] if auth["user_info"] # we get this only from FB
      user.access_token = auth["credentials"]["token"]
    end
  end

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
