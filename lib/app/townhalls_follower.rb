require 'twitter'
require 'awesome_print'
require 'dotenv'
require_relative 'townhalls_convert_to_hash'

class Follower

	def initialize
		# quelques lignes qui enregistrent les clés d'APIs
		@client = Twitter::REST::Client.new do |config|
			Dotenv.load
			config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
			config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
			config.access_token        = ENV['TWITTER_TOKEN']
			config.access_token_secret = ENV['TWITTER_TOKEN_SECRET']
		end

	end

	def search_handle(research)
		begin
			result = @client.user_search("mairie " + research)[0].screen_name
		rescue NoMethodError
			begin
				result = @client.user_search("ville " + research)[0].screen_name
			rescue NoMethodError
				begin
					result = @client.user_search(research)[0].screen_name
				rescue NoMethodError
					result = 'Aucun compte Twitter trouvé..'
				end
			end
		ensure
			return result
		end
	end

	def search_all_handle
		notfound = "Aucun compte Twitter trouvé.."
		array = Converter.new.return_value("name", "email")
		for user in array
			handle_of_user = search_handle(user)
			puts "#{"Le handle Twitter de la mairie de".yellow} #{user.red} #{"est :".yellow} #{handle_of_user.red}"
			unless handle_of_user == notfound
				@client.follow(handle_of_user)
				puts "Abonnement à #{handle_of_user} fait !".green
			end
		end
	end
end
