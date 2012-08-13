#!/bin/env ruby
# encoding: utf-8

class AlbumsController < ApplicationController
  before_filter :check_clearance, :only => [:create]
  before_filter :authenticate_user!, :only => [:switch]

  def index
    if params[:user]
      @user_id = params[:user]
    else
      @user_id = current_user.id
    end
    respond_to do |format|
      format.json {
        render :json => {:albums => User.find(@user_id).albums.map(&:basic_representation)}
      }
      format.html
    end
  end

  def show
    @id = params[:id]
    respond_to do |format|
      format.json {
        render :json => {:album => Album.find(@id).basic_representation}
      }
      format.html
    end
  end

  def create
    params[:album][:user_id] = current_user.id
    album = Album.new(params[:album])
    if album.save
      render :json => {:album => album.basic_representation}
    else
      render :json => "Название нельзя оставлять пустым."
    end
  end

  def switch
    # simple method to swap album positions
    a1 = Album.find_by_position(params[:before])
    a2 = Album.find_by_position(params[:after])
    a1.update_attribute(:position, params[:after])
    a2.update_attribute(:position, params[:before])
    render :json => {:success => "switched"}
  end

  def avatar
    render :json => {:album => Album.where(:user_id => params[:id], :album_type => "avatars").first.basic_representation}
  end

  protected

  def check_clearance
    unless !params[:album].nil?
      render :json => "Ошибка доступа к альбому."
    end
  end
end
