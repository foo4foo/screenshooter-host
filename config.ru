# This file is used by Rack-based servers to start the application.
require "yaml"
require "rqrcode"
require_relative "config/environment"

HOST_UUID_PATH = "config/host_uuid.yml"
QR_CODE_PATH = "config/qr_code.svg"

firebase_url = ENV["SCREENSHOOTER_FIREBASE_URL"]
firebase_secret = ENV["SCREENSHOOTER_FIREBASE_SECRET"]
firebase = Firebase::Client.new(firebase_url, firebase_secret)

NGROK_URL = "https://170e89e7.ngrok.io"

def generate_qr(secret)
  qrcode = RQRCode::QRCode.new(secret)
  svg = qrcode.as_svg(offset: 0, color: "000",
                      shape_rendering: "crispEdges",
                      module_size: 11)
  File.open(QR_CODE_PATH, "w") { |f| f.write(svg) }
end

if File.exist?(HOST_UUID_PATH)
  file = YAML.load_file(HOST_UUID_PATH)
  # get ngrok url and update file
  puts firebase.get("hosts/#{file["host"]["uuid"]}").body
else
  host_uuid = SecureRandom.hex(10)
  response = firebase.push("hosts", {url: NGROK_URL})

  uuid = response.body["name"]

  if response.success? and response.code == 200
    File.open(HOST_UUID_PATH, "w") { |f| f.write("host:\n  uuid: #{uuid}\n  url: #{NGROK_URL}") }
    generate_qr(uuid)
  end
end

run Rails.application
