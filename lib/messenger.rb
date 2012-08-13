require 'net/http'

module Messenger
  def self.notify(action, user, data)
    url = "#{Rails.configuration.socket_host}/message/#{action}/#{user}"
    res = Net::HTTP.post_form(URI.parse(URI.encode(url)), data)

    # 200 implies successfully sent.
    # There is nothing we can do if the targe user is not online(404)
    # For any other error, raise Exception
    unless ["200", "404"].include? res.code
      raise Exception.new("Error: #{res.code}")
    end
    return res
  end

  def self.chat(message)
    url = "#{Rails.application.config.socket_host}/chat/general"
    res = Net::HTTP.post_form(URI.parse(URI.encode(url)), {"content" => message.content, "user_id" => message.user_id, "username" => message.user.full_name, "avatar" => message.user.get_icon})

    # 200 implies successfully sent.
    # There is nothing we can do if the targe user is not online(404)
    # For any other error, raise Exception
    unless ["200", "404"].include? res.code
      raise Exception.new("Error: #{res.code}")
    end
    return res
  end
end