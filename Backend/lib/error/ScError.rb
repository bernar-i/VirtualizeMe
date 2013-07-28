#!/usr/bin/env ruby

module SkyCloud
  class ScError < RuntimeError
    attr_reader :iErrorId, :sErrorMsg

    def initialize iId, sMsg
      @iErrorId = iId
      @sErrorMsg = sMsg
    end

    def setId iId
      @iErrorId = iId
    end

    def setMsg sMsg
      @sErrorMsg = sMsg
    end

    def getId
      return @iErrorId
    end

    def getMsg
      return @sErrorMsg
    end
  end
end