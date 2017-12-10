# MiniDisc

Mini service discovery in Ruby

## Description

I recently extracted MiniDisc from a toy project I've been working on. It offers a single line interface for common patterns in service discovery that I'd been redundantly implementing.  

Under the hood, it wraps the DNSSD gem and is cross compatible with services using that.  It adds helpers for common tasks like matching services by name, dynamically overriding discovery, error handling, logging


todo:
what is the relationship between DNSSD and Bonjour? explain here
what is the relationship between DNSSD, Bonjour and DNS explain here
on what network scope are broadcasted visible? eg local network?
what features from DNSSD are lost exactly?  explain
what is mdns?

## Requirements

### Linux

* dns-sd
* avahi 0.6.25+ (plus libavahi-compat-libdnssd-dev on Debian)

## Usage

To broadcast a service use something like:

```ruby
require "minidisc"

MiniDisc::Registry.add(:http, 8080, id: "my-service-instance1")
```

To discover other services use

```ruby
MiniDisc::Discover.resolve(:http, id: /^my-service/) do |services|
  ...
end
```

## Installation

`gem install minidisc`

or when Bundler, add this to your Gemfile

`gem "minidisc"`

## License

Apache 2.0, See LICENSE file

Copyright (c) 2017 [Ari Russo](http://arirusso.com)
