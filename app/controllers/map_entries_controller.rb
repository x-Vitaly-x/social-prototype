#!/bin/env ruby
# encoding: utf-8

class MapEntriesController < ApplicationController
  def index
    respond_to do |format|
      format.json {
        if params[:x]
          ids = params[:x].collect { |p| p.to_i }
          p ids
        else
          ids=[]
        end
        render :json => {:map_entries => MapEntry.excluding_ids(ids).in_bounds([[params[:lo][:lat], params[:lo][:lng]], [params[:hi][:lat], params[:hi][:lng]]]).map(&:basic_representation)}
        #render :json => {:map_entries => MapEntry.all.map(&:basic_representation)}
      }
      format.html
    end
  end

  def create
    params[:map_entry][:user_id] = current_user.id
    map_entry = MapEntry.new(params[:map_entry])
    if map_entry.save
      render :json => {:map_entry => map_entry.basic_representation}
    else
      render :json => "Название и описание нельзя оставлять пустыми."
    end
  end
end
