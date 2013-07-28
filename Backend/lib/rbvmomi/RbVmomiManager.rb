#!/usr/bin/env ruby

require 'rconfig'

module SkyCloud
  class RbVmomiManager
    attr_reader :oVim

    def initialize
      @oVim = nil
    end

    # TO DO
    # Enregistrer dans le fichier Rconfig
    def setInfos aParams
      #RConfig.vsphere.endpoint.host => aParams[:host]
      #RConfig.vsphere.endpoint.user => aParams[:user]
      #RConfig.vsphere.endpoint.password => aParams[:password]
      #RConfig.vsphere.endpoint.insecure => aParams[:insecure]
    end

    def getInfos
      hConfig = {
        :host => RConfig.vsphere.endpoint.host,
        :user => RConfig.vsphere.endpoint.user,
        :password => RConfig.vsphere.endpoint.password,
        :insecure => RConfig.vsphere.endpoint.insecure
      }
      hConfig
    end

    def connect
      hConfig = {
        :host => RConfig.vsphere.endpoint.host,
        :user => RConfig.vsphere.endpoint.user,
        :password => RConfig.vsphere.endpoint.password,
        :insecure => RConfig.vsphere.endpoint.insecure
      }
      @oVim = RbVmomi::VIM.connect hConfig
    end

    def close
      @oVim.close
    end

  end
end
