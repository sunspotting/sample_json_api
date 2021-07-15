class TicketsController < ApplicationController
  def create
    @ticket = Ticket.create!(ticket_params)
    render json: @ticket, status: :ok
  end

  def ticket_params
    params.require(:ticket).permit(:user_id, :title, :tags)
    #params.except(:tags)
  end

  def ticket_tags
    params.require(:ticket).permit(:user_id, :title,:tags)
    params[:tags]
  end

end
