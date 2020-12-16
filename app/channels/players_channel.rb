class PlayersChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    @player = Player.find(params[:player])
    stream_for @player
  end

  def received(data)

  end

  def unsubscribed
    stop_all_streams
    # Any cleanup needed when channel is unsubscribed
  end
end
