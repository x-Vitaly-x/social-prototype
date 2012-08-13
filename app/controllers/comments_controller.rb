#!/bin/env ruby
# encoding: utf-8

class CommentsController < ApplicationController

  def index
    comments = Comment.real.where(request.query_parameters)
    if !comments.empty?
      render :json => {:comments => comments.map(&:basic_representation)}
    else
      render :json => {:comments => []}
    end
  end

  def create
    params[:comment][:user_id] = current_user.id
    comment = Comment.new(params[:comment])
    if comment.save
      render :json => {:comment => comment.basic_representation}
    else
      render :json => "Пустые комменты не принимаются.".encode!("UTF-8")
    end
  end
end
