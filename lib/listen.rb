Thread.abort_on_exception = true
require "timers"
require "discordrb"
require "./lib/handlers/discord"

# Listen for events from Discord and systemd
module Listen
  def self.start
    @bot = Discordrb::Commands::CommandBot.new(token: ENV["TOKEN"], prefix: ENV["PREFIX"])
    @bot.ready { game_server_hooks() }
    @bot.run()
  end

  def self.game_server_hooks
    server = @bot.servers.dig(ENV["SERVER_ID"].to_i)
    games = %w[starbound rust minecraft]
    timer = Timers::Group.new
    timer.now_and_every(15) { DiscordHelpers.game_announce(server, games) }
    Thread.new { loop { timer.wait } }
  end
end
