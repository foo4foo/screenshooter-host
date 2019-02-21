# This file is used by Rack-based servers to start the application.
require "yaml"
require_relative "config/environment"

HOST_UUID_PATH = "config/host_uuid.yml"

firebase_url = ENV["SCREENSHOOTER_FIREBASE_URL"]
firebase_secret = ENV["SCREENSHOOTER_FIREBASE_SECRET"]
firebase = Firebase::Client.new(firebase_url, firebase_secret)

NGROK_URL = "https://localhost:3000"

if File.exist?(HOST_UUID_PATH)
  file = YAML.load_file(HOST_UUID_PATH)
  # get ngrok url and update file
  puts firebase.get("hosts/#{file["host"]["uuid"]}").body
else
  host_uuid = SecureRandom.hex(10)
  response = firebase.push("hosts", {url: NGROK_URL})

  if response.success? and response.code == 200
    File.open(HOST_UUID_PATH, "w") { |f| f.write("host:\n  uuid: #{response.body["name"]}\n  url: #{NGROK_URL}") }
  end
end

run Rails.application
