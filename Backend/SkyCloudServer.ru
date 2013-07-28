require 'rubygems'
require 'rack'
require 'rconfig'

#########################
# Laod Path for library #
#########################

app_dir = File.dirname(File.absolute_path(__FILE__))
$LOAD_PATH << File.join(app_dir,"lib")

############################################
# Environment Configuration for OpenNebula #
############################################

#ONE_LOCATION = ENV["ONE_LOCATION"]
#
#if !ONE_LOCATION
#    RUBY_LIB_LOCATION = "/usr/lib/one/ruby"
#else
#    RUBY_LIB_LOCATION = ONE_LOCATION + "/lib/ruby"
#end
#
#$: << RUBY_LIB_LOCATION

#####################
#  FILES REQUIRED   #
#####################

require ::File.expand_path('../lib/logger/MyLogger.rb', __FILE__)
require ::File.expand_path('../lib/logger/ScLogger.rb', __FILE__)
require ::File.expand_path('../source/WebService.rb',  __FILE__)

#####################
#  CONFIG INSTANCE  #
#####################

RConfig.setup do |config|
  config.load_paths = [File.expand_path("../config/", __FILE__)]
end

#####################
#  LOGGER INSTANCE  #
#####################

SkyCloud::ScLogger.instance
use Rack::CommonLogger, SkyCloud::ScLogger.instance.getLogger

#####################
#  RUN APPLICATION  #
#####################

run SkyCloud::WebService