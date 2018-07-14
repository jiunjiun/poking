class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, authentication_keys: [:login]

  has_many :observers
  has_many :senders

  validates :email, uniqueness: true
  validates :username, uniqueness: true, presence: true

  before_create :setup
  after_create  :setup_sender

  attr_writer :login

  module Role
    ADMIN    = 'admin'
    BUSINESS = 'business'
    USER     = 'user'
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def login
    @login || self.username || self.email
  end

  def devise_mailer
    DeviserMailer
  end

  User::Role.constants.each do |role|
    class_eval %Q{
      def is_#{role.downcase}?
        self.role == '#{role.downcase}'
      end
    }
  end

  private
  def setup
    setup_name
  end

  def setup_name
    self.name = self.username
  end

  def setup_sender
    self.senders.create! name: self.name, email: self.email
  end
end
