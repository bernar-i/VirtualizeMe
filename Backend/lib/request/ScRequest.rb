#!/usr/bin/env ruby

module SkyCloud
  class ScRequest
    attr_reader :bSuccessful, :oResponse

    def initialize bSuccessful, oResponse = nil
      @bSuccessful = bSuccessful
      @oResponse = oResponse
    end

    def setSuccessful bSuccessful
      @bSuccessful = bSuccessful
    end

    def setResponse oResponse
      @oResponse = oResponse
    end

    def getSuccessful
      return @bSuccessful
    end

    def getResponse
      return @oResponse
    end

    def toString
      if @oResponse.nil?
        oMessage = { 'screquest' => { 'successful' => @bSuccessful }}
      elsif @oResponse.kind_of? SkyCloud::ScError
        oMessage = { 'screquest' => { 'successful' => @bSuccessful, 'error' => { 'errorid' => @oResponse.getId, 'msg' => @oResponse.getMsg }}} 
      else
        oMessage = { 'screquest' => { 'successful' => @bSuccessful, 'return' => @oResponse }}
      end
      return oMessage
      #rack_response(oMessage)
      #Rack::Response.new(oMessage).finish
    end
  end
end
