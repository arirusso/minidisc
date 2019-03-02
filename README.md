# MiniDisc

Mini service discovery in Ruby

## Description

I recently extracted MiniDisc from a personal project I've been working on. It offers a single line interface for common patterns in service discovery that I'd been redundantly implementing.

Under the hood it wraps the DNSSD gem and is cross compatible with services using that.  It adds helpers for common tasks like matching services by name, dynamically overriding discovery, error handling, logging

## Requirements

### Linux

* dns-sd
* avahi 0.6.25+ (plus libavahi-compat-libdnssd-dev on Debian)

## Usage

To broadcast a service use something like:

```ruby
require "minidisc"

MiniDisc::Network.add(:http, 8080, id: "my-service-instance1")
```

To discover other services use

```ruby
MiniDisc::Network.find_all(:http, id: /^my-service/) do |services|
  ...
end
```

## Installation

`gem install minidisc`

or when Bundler, add this to your Gemfile

`gem "minidisc"`

## License

Apache 2.0, See LICENSE file

Copyright (c) 2017-2019 [Ari Russo](http://arirusso.com)
