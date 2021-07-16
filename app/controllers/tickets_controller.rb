class TicketsController < ApplicationController
  include TagsHelper

  def create
    @ticket = Ticket.create!(ticket_params)
    process_tags
    render json: @ticket, status: :ok
  end

  private

  def ticket_params
    params.require(:ticket).permit(:user_id, :title)
  end

  def process_tags
    if params[:tags]
      params[:tags].each {|t| update_tag(t) }
    end
    send_top_tag
  end
end
