class TicketsController < ApplicationController
  include TagsHelper

  def create
    @ticket = Ticket.new(ticket_params)
    if @ticket.valid?
      @ticket.save
      render_object = check_tags 
    else
      render_object = [json: {object: @ticket, error: @ticket.errors.full_messages  }.to_json, status: :unprocessable_entity]
    end
    # for more complicated error handling I would use a gem
    render *render_object
  end

  private

  def ticket_params
    puts "GOOOOOOOOOOOOOOOOOOOOOOOOOOO" 
    puts params
    puts "--------------------------------------"
    params.require(:ticket)
    params[:ticket].require(:user_id)
    params[:ticket].require(:title)
    params[:ticket].delete(tags: [])
  end

  def check_tags
    if params.has_key?(:tags)
      if params[:tags].size < 5
        params[:tags].each {|t| update_tag(t) }
        send_top_tag
      else
        render_object = [json: {object: @ticket, error: "More than 5 tags submitted."  }.to_json, status: :unprocessable_entity]
      end
    end
    render_object ||= [json: @ticket, status: :ok]
  end
end
