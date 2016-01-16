class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :pacts

  has_many :goals, dependent: :destroy
  accepts_nested_attributes_for :goals

  has_many :workouts, dependent: :destroy
  accepts_nested_attributes_for :workouts

  has_many :payments, dependent: :destroy
  accepts_nested_attributes_for :payments
end
