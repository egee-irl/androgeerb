require 'rest-client'
require 'discordrb'
require 'json'

file = File.read('blob.json')
json = JSON.parse(file)
bot = Discordrb::Bot.new token: ENV['RBBY']

bot.ready do
  bot.game = json['games'].sample
end

bot.member_join do |event|
  event.server.default_channel.send_message event.user.display_name + ' has joined! :metal:'
end

bot.member_leave do |event|
  event.server.channels_by_id[ENV['DEBUG_CHANNEL']].send_message event.user.display_name + ' just left the server!'
end

bot.message do |event|
  event.respond(message_engine(event.content)) if event.content.include? '-'
end

def message_engine(message)
  case message
  when '-ping'
    'pong'
  when '-fortune'
    '``' + `fortune -s | cowsay` + '``'
  when '-catpic'
    RestClient.get('http://thecatapi.com/api/images/get?format=src&type=jpg').request.url
  when '-catgif'
    RestClient.get('http://thecatapi.com/api/images/get?format=src&type=gif').request.url
  when '-chucknorris'
    JSON.parse(RestClient.get('http://api.icndb.com/jokes/random?exclude=[explicit]'))['value']['joke']
  when '-help'
    'Not Implemented'
  when '-commands'
    'Not Implemented'
  when '-ghostbusters'
    '``' + `cowsay -f ghostbusters Who you Gonna Call` + '``'
  when '-moo'
    '``' + `apt-get moo` + '``'
  else
    'Nothing matched, still Not Implemented'
  end
end

bot.run
