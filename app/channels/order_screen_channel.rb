class OrderScreenChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'order_screen_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
