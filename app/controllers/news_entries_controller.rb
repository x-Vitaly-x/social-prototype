class NewsEntriesController < ApplicationController
  before_filter :authenticate_user!, :only => [:create]

  def index
    # get the last/next 20 or so news
    news_entries = NewsEntry.search(params[:search]).next_stack(params[:offset].to_i, Rails.configuration.news_entry_offset)
    render :json => {:news_entries => news_entries.map(&:basic_representation), :offset => params[:offset].to_i + Rails.configuration.news_entry_offset}
  end

  def index_x
    # get all the latest news since params
    news_entries = NewsEntry.made_since(params[:last_timestamp])
    render :json => {:news_entries => news_entries, :offset => params[:offset].to_i + Rails.configuration.news_entry_offset}
  end

  def new

  end

  def create
    news_entry = current_user.news_entries.build(params[:news_entry])
    if news_entry.save
      render :json => {:news_entry => news_entry.basic_representation}
    else
      render :json => {:errors => news_entry.errors.full_messages}
    end
  end

  def show
    @id = params[:id]
    respond_to do |format|
      format.json {
        news_entry = NewsEntry.find(@id)
        render :json => {:news_entry => news_entry.opened_representation}
      }
      format.html
    end
  end

  def edit
  end

  def delete
  end
end
