#!/usr/bin/env ruby

require 'rbvmomi'

module SkyCloud
  autoload :RbVmomi, "rbvmomi/RbVmomiManager"

  class RbVmomiController < Grape::API
    namespace :rbvmomi do
      before {
        begin
          # TODO : Add authentication method
          # sc_authenticate!
          #sc_connect
        rescue ScError => e
          # TODO : Try to use a better method
          # - Format not use
          # - Syntax not consistent with the rest of the code
          throw :error, :status => 200, :message => SkyCloud::ScRequest.new(false, e).toString
        end
      }

      desc "Methods for RbVmomi configuration"
      namespace 'configuration' do
        desc "Set vSphere SDK endpoint configuration"
        params do
          requires :host, :type => String, :desc => ""
          requires :user, :type => String, :desc => ""
          requires :password, :type => String, :desc => ""
          requires :insecure, :type => String, :desc => ""
        end
        post do
          begin
            sc_log SkyCloudLogger::LOG_INFO, "[RbVmomi] Start set vSphere SDK endpoint configuration"
            RbVmomiManager.new.setInfos(params)
            sc_response true
          rescue ScError => e
            sc_response e
          end
        end

        desc "Get vSphere SDK endpoint configuration"
        get do
          begin
            sc_log SkyCloudLogger::LOG_INFO, "[RbVmomi] Start get vSphere SDK endpoint configuration"
            hConfig = RbVmomiManager.new.getInfos
            sc_response hConfig
          rescue ScError => e
            sc_response e
          end

        end

      end

    end
  end
end
