# encoding: utf-8
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name_first             :string(255)
#  name_last              :string(255)
#  nickname               :string(255)
#  gender                 :boolean
#  facebook_avatar_url    :string(255)
#  facebook_id            :integer
#  vkontakte_avatar_url   :string(255)
#  vkontakte_id           :integer
#  username               :string(255)
#  admin                  :boolean
#  avatar_id              :integer
#  description            :text
#  settings               :text
#

#!/bin/env ruby
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  validates_presence_of :username
  validates_uniqueness_of :username

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessor :login
  attr_accessible :login, :username, :email, :name_first, :name_last, :nickname, :gender, :facebook_avatar_url, :facebook_id, :vkontakte_avatar_url, :vkontakte_id, :password, :password_confirmation, :remember_me

  has_many :chat_messages, :dependent => :destroy
  has_many :news_entries, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :albums, :dependent => :destroy
  belongs_to :avatar, :class_name => "Image", :foreign_key => "avatar_id", :dependent => :destroy

  has_many :followers, :through => :friendship_by, :source => :follower # -User

  after_create :create_avatar_album

  def follows
    User.find_by_sql "
    select * from users
      where id in
        (select followee_id from friendships
          where follower_id = #{id});"
  end

  def followers
    User.find_by_sql "
    select * from users
      where id in
        (select follower_id from friendships
          where followee_id = #{id});"
  end

  def friends # find your friends, those who follow you and those you follow as well
    User.find_by_sql "
    select * from users
      where id in
        (select f2.follower_id from friendships as f1 inner join friendships as f2 on (f1.follower_id = f2.followee_id) and (f1.followee_id = f2.follower_id) and (f1.follower_id = #{id}))"
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", {:value => login.strip.downcase}]).first
  end

  def basic_representation(*args)
    {
        :id => id,
        :name_first => name_first,
        :name_last => name_last,
        :nickname => nickname,
        :gender => gender,
        :avatar => get_images,
        :facebook_id => facebook_id,
        :facebook_avatar_url => facebook_avatar_url,
        :vkontakte_id => vkontakte_id,
        :vkontakte_avatar_url => vkontakte_avatar_url,
        :username => username,
        :admin => admin,
        :description => YAML.load(description.to_s),
        :settings => self.parse(settings),
        :relation => self.relation(args[0]),
        :friends => self.friends.map(&:list_representation)
    }
  end

  def list_representation
    # return name, avatar and id. nothing more
    {
        :id => id,
        :name => name_first.to_s + " " + nickname.to_s + " " + name_last.to_s,
        :avatar => get_icon
    }
  end

  def relation(user_id)
    # returns whether the user is you, your friend, your follower, or someone you follow
    if user_id.nil?
      return "offline" # you are offline. user status is irrelevant
    else
      if user_id == id
        return "self"
      else
        f = Friendship.find_by_sql "
        select * from friendships
          where
            (follower_id = #{id} and followee_id = #{user_id})
            or
            (followee_id = #{id} and follower_id = #{user_id});"
        if f.size == 0
          return "unrelated"
        elsif f.size == 2
          return "friend" # only friends can have two relationships, one for each side
        elsif f.size == 1
          # see who follows who
          if f.first.follower_id == id
            return "follower"
          elsif f.first.followee_id == id
            return "followee"
          end
        end
      end
    end
    return "error on #{id.to_s} and #{user_id.to_s}"
  end

  def parse(settings)
    if settings.nil?
      return nil
    end
  end

  def create_avatar_album
    self.albums.create(:title => "фото с моей страницы", :album_type => "avatars") if Album.where(:user_id => self.id, :album_type => "avatars").empty?
    self.albums.create(:title => "фото со мной", :album_type => "markups") if Album.where(:user_id => self.id, :album_type => "markups").empty?
  end

  def get_images
    {
        :icon => get_icon,
        :image => get_image
    }
  end

  def get_icon
    return (self.avatar.nil? ? (facebook_avatar_url || vkontakte_avatar_url) : self.avatar.url_thumb)
  end

  def get_image
    return (self.avatar.nil? ? "/assets/no-picture.jpg" : self.avatar.url_original)
  end

  def full_name
    return name_first.to_s + " " + name_last.to_s
  end

  protected

  def email_required?
    false
  end
end
