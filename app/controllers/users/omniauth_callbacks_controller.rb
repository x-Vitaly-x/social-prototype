#!/bin/env ruby
# encoding: utf-8

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    data = env["omniauth.auth"].extra.raw_info
    if user = current_user
      # user is signed in. update his facebook credentials
      # p data
      user.update_attributes!(:name_first => data.first_name, :name_last => data.last_name, :gender => ((data.gender == "male") ? 1 : 0), :facebook_id => data.id.to_s, :facebook_avatar_url => request.env["omniauth.auth"].info.image.to_s)
      redirect_to settings_path
    else
      # no user online. see whether a user with those credentials exists
      if user = User.where(:facebook_id => data.id).first
        sign_in_and_redirect user, :event => :authentication
      else
        flash[:error] = "Вы еще не зарегистрированы в системе. Зарегистрируйтесь и только потом привяжите свою анкету к социальной сети."
        flash.keep
        p flash
        #User.create!(:username => "facebook_user_" + data.id.to_s, :email => data.email, :name_first => data.first_name, :name_last => data.last_name, :gender => ((data.gender == "male") ? 1 : 0), :facebook_id => data.id.to_s, :facebook_avatar_url => access_token.info.image.to_s, :password => Devise.friendly_token[0, 20])
        redirect_to new_user_registration_url
      end
    end
  end

  def vkontakte

    data = env["omniauth.auth"].extra.raw_info
    if user = current_user
      # user is signed in. update his vkontakte credentials
      p env["omniauth.auth"]
      p "XXX"
      p data
      user.update_attributes!(:name_first => data.first_name, :name_last => data.last_name, :nickname => data.nickname, :gender => ((data.sex == 2) ? 1 : 0), :vkontakte_id => data.uid.to_s, :vkontakte_avatar_url => data.photo_big)
      redirect_to settings_path
    else
      # no user online. see whether a user with those credentials exists
      if user = User.where(:vkontakte_id => data.uid.to_s).first
        sign_in_and_redirect user, :event => :authentication
      else
        flash[:error] = "Вы еще не зарегистрированы в системе. Зарегистрируйтесь и только потом привяжите свою анкету к социальной сети."
        flash.keep
        p flash
        redirect_to new_user_registration_url
      end
    end
  end

  def failure
    p "XXX"
    data = request.env["omniauth.auth"]
    p data
    redirect_to settings_path
  end
end