class ChatMessagesController < ApplicationController
  before_filter :authenticate_user!, :only => [:create]
  def create
    message = current_user.chat_messages.build(:content => params[:message])
    if message.save
      res = Messenger::chat(message)
      render :json => {:message => message.basic_representation}
    else
      render :json => "Write something!"
    end
  end
  def index
    # get the last/next 20 or so chat messages
    chat_messages = ChatMessage.next_stack(params[:offset].to_i, Rails.configuration.chat_message_offset)
    render :json => {:messages => chat_messages.map(&:basic_representation), :offset => params[:offset].to_i + Rails.configuration.chat_message_offset}
  end
  
end
