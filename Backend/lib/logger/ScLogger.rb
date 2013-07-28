#!/usr/bin/env ruby

require 'singleton'
require 'rconfig'

module SkyCloud
  LOG_DEBUG   = 'debug'
  LOG_INFO    = 'info'
  LOG_WARN    = 'warn'
  LOG_ERROR   = 'error'
  LOG_FATAL   = 'fatal'

  class ScLogger
    include Singleton

    attr_reader :oLogger, :sLevel


    def initialize
      startLog
    end

    def startLog
      oFile = File.open(config.path, "a+")
      @oLogger = MyLogger.new oFile, config.shift_age, config.shift_size
      @oLogger.level = MyLogger.const_get(config.level)
      @oLogger.datetime_format = "[%Y-%m-%d %H:%M:%S]"
      @oLogger.formatter = proc do |severity, datetime, progname, msg|
        "[#{datetime}] #{severity} #{msg}\n"
      end
    end

    def putLog sLvl, sMsg
      startLog
      if (config.stdout == true)
        time = Time.new
        puts time.strftime("[%Y-%m-%d %H:%M:%S]") + " " + sLvl.upcase + "  #{sMsg}"
      end
      begin
        method = @oLogger.method(sLvl)
      rescue
        method = @oLogger.method(SkyCloud::LOG_FATAL)
      end
      method.call sMsg
      @oLogger.close
    end

    def getLogger
      return @oLogger
    end

    def config
      RConfig.settings.logger
    end
  end
end
