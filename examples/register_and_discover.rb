#!/usr/bin/env ruby
$:.unshift(File.join("..", "lib"))

require "minidisc"

# Broadcast a service
server = MiniDisc::Network.add(:http, 8080, id: "my-service-instance1")

# Wait
sleep(3)

# Discover that service
MiniDisc::Network.find_all(:http, id: /^my-service/) do |services|
  p services
end
