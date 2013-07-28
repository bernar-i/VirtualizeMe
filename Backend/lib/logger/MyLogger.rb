#!/usr/bin/env ruby

require 'logger'

module SkyCloud
  class MyLogger < Logger
  	alias write <<
  end
end
