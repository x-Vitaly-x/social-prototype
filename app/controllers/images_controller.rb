#!/bin/env ruby
# encoding: utf-8

class ImagesController < ApplicationController
  before_filter :check_clearance, :only => [:create]
  before_filter :authenticate_user!, :only => [:switch]

  def index
    images = Image.by_user(params[:user_id], params[:offset].to_i, Rails.configuration.image_offset)
    render :json => {:images => images.map(&:basic_representation), :offset => params[:offset].to_i + Rails.configuration.image_offset}
  end

  def create
    image = Image.create(params[:image])
    render :json => {:image => image.basic_representation}
  end

  def update
    image = Image.find(params[:id])
    image.update_attributes(params[:image])
    render :json => {:image => image.basic_representation}
  end

  def show
    @id = params[:id]
    respond_to do |format|
      format.json {
        render :json => {:image => Image.find(@id).basic_representation}
      }
      format.html
    end
  end

  def switch
    # simple method to swap album positions
    a1 = Image.find_by_position(params[:before])
    a2 = Image.find_by_position(params[:after])
    a1.update_attribute(:position, params[:after])
    a2.update_attribute(:position, params[:before])
    render :json => {:success => "switched"}
  end

  protected

  def check_clearance
    unless !params[:image].nil? and params[:image][:album_id] and Album.find(params[:image][:album_id]).user_id == current_user.id
      render :json => "Ошибка доступа к картинке."
    end
  end
end
