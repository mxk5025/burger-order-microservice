class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :receive_completed
  def show
    @order = Order.new
  end

  def create
    # Here we would submit to our SNS topic
    # Amazon::SNS.send()

    # Set the instance variable back to a new order so another may be created
    @order = Order.new

    response_hash = {
      action: 'order_placed',
      order: order_params
    }

    # Tell the channel an order has been placed
    ActionCable.server.broadcast 'order_screen_channel', content: response_hash

    # Return successful created
    :created
  end

  def receive_completed
    response_hash = {
      action: 'order_completed',
      order: order_completed_params
    }
    ActionCable.server.broadcast 'order_screen_channel', content: response_hash
  end

  private

  def order_params
    params.require(:order).permit(:id, :name)
  end

  def order_completed_params
    params.require(:order).permit(:id)
  end
end
