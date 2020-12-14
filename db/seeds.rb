# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'rest-client'

resp = JSON.parse(RestClient.get 'https://cah.greencoaststudios.com/api/v1/official/main_deck')['black']

resp.each do |card|
    Prompt.create(text: card['content']) if card['pick'] == 1
end