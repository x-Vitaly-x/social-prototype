#!/bin/env ruby
# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_aws_permission, :only => [:aws_policy]
  before_filter :user_check

  def aws_policy
    options = {}
    options[:s3_config_filename] = "#{Rails.root}/config/s3.yml"
    config = YAML.load_file(options[:s3_config_filename])[Rails.env].symbolize_keys
    p config
    bucket            = config[:bucket]
    access_key_id     = config[:access_key_id]
    secret_access_key = config[:secret_access_key]
    options[:key] ||= "albums/" + params[:album_id]  # folder on AWS to store file in
    options[:acl] ||= 'public-read'
    options[:expiration_date] ||= 10.hours.from_now.utc.iso8601
    options[:max_filesize] ||= 10.megabytes
    options[:content_type] ||= 'image/' # Videos would be binary/octet-stream
    options[:filter_title] ||= 'Images'
    options[:filter_extentions] ||= 'jpg,jpeg,gif,png,bmp'
    policy = Base64.encode64(
        "{'expiration': '#{options[:expiration_date]}',
        'conditions': [
          {'bucket': '#{bucket}'},
          {'acl': '#{options[:acl]}'},
          {'success_action_status': '201'},
          ['content-length-range', 0, #{options[:max_filesize]}],
          ['starts-with', '$key', '#{options[:key]}'],
          ['starts-with', '$Content-Type', ''],
          ['starts-with', '$name', ''],
          ['starts-with', '$Filename', '']
        ]
      }").gsub(/\n|\r/, '')

    signature = Base64.encode64(
        OpenSSL::HMAC.digest(
            OpenSSL::Digest::Digest.new('sha1'),
            secret_access_key, policy)).gsub("\n","")
    render :json => {:access_key_id => access_key_id, :policy => policy, :signature => signature, :bucket => bucket}
  end

  protected

  def check_aws_permission
    unless params[:album_id] and ((Album.find(params[:album_id]).user_id == current_user.id) rescue false)
      render :json => "Ошибка. У вас нет доступа к этому альбому."
    end
  end

  def user_check
    @current_user = current_user
  end
end
