#!/bin/env ruby
# encoding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:set_avatar, :set_description, :settings, :toggle_friendship]

  def update
  end

  def index
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.json {
        render :json => {:user => @user.basic_representation(current_user.id)}
      }
      format.html
    end
  end

  def set_avatar
    avatar = (Image.find(params[:avatar_id]) rescue nil)
    if avatar.nil? or (avatar.album.user_id != current_user.id)
      # error
      render :json => "Нет доступа к картинке"
    else
      current_user.update_attribute(:avatar_id, avatar.id)
      render :json => {:avatar => current_user.get_images}
    end
  end

  def settings
    @user = current_user
  end

  def toggle_friendship
    # if unrelated => follow
    # if follower => befriend
    # if followee => unfollow
    # if friend => unfriend and unfollow
    u1 = params[:user_id]
    u = User.find(u1)
    c = current_user
    u2 = c.id
    s = u.relation(u2)
    case s
      when "followee"
        #current user follows that dude. toggle should destroy the relation between them
        Friendship.where(:follower_id => u2, :followee_id => u1).first.destroy
      when "follower"
        #current user is followed by that dude. toogle should make current user friends with the guy
        Friendship.create!(:follower_id => u2, :followee_id => u1)
      when "friend"
        #current user is friends with the guy. unfriend him. destroy any relationship they have
        f = Friendship.find_by_sql "
        select * from friendships
          where
            (follower_id = #{u1} and followee_id = #{u2})
            or
            (followee_id = #{u1} and follower_id = #{u2});"
        f.each { |x| x.destroy }
      when "unrelated"
        # unrelated. follow him
        Friendship.create!(:follower_id => u2, :followee_id => u1)
      else
        p "what the fuck?"
    end
    render :json => {:relation => u.relation(u2)}
  end

  def set_description
    current_user.update_attribute(:description, params[:description].collect { |c| c.flatten }.to_yaml)
    render :json => {:description => YAML.load(current_user.description)}
  end
end
