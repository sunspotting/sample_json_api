class TicketsController < ApplicationController
  include TagsHelper

  def create
    @ticket = Ticket.new(ticket_params)
    if @ticket.valid?
      @ticket.save
      render_object = check_tags params[:ticket]
    else
      render_object = [json: {object: @ticket, error: @ticket.errors.full_messages }.to_json, status: :unprocessable_entity]
    end
    # for more complicated error handling perhaps a gem would be appropriate here
    render *render_object
  end

  private

  def ticket_params
    params.require(:ticket).permit(:user_id, :title)
  end

  def check_tags(in_params)
    if in_params.has_key?(:tags)
      tags = in_params[:tags]
      if tags.size < 5
        tags.each {|t| update_tag(t) }
        send_top_tag
      else
        render_object = [json: {object: @ticket, error: "More than 5 tags submitted."  }.to_json, status: :unprocessable_entity]
      end
    end
    render_object || [json: @ticket, status: :ok]
  end
end
