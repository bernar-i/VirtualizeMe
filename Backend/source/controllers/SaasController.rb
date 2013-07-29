#!/usr/bin/env ruby

require 'rbvmomi'

require 'digest/sha1'

module SkyCloud
  autoload :SaasManager, "saas/SaasManager"

  class SaasController < Grape::API
    namespace :saas do
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

      desc "Setup OwnCloud on a Virtual Machine"
      namespace 'owncloud' do
        desc ""
        params do
          requires :vm_name, :type => String, :desc => ""
          requires :username, :type => String, :desc => ""
          requires :password, :type => String, :desc => ""
        end
        post do
          begin
            sc_log SkyCloudLogger::LOG_INFO, "[SaaS] Configure virtual machine"
            oSaasManager = SaasManager.new(params)
            sYml = "config/#{params[:vm_name]}_saas.yml"
            if !File.exist?(sYml)
              oSaasManager.configureOwncloud(params)
            end
            oSaasManager.user(params)
            oSaasManager.setYml(params)
            sc_response true
          rescue ScError => e
            sc_response e
          end
        end
      end

      desc "Get config saas"
      namespace 'config' do
        desc ""
        params do
          requires :vm_name, :type => String, :desc => ""
        end
        post do
          begin
            sc_log SkyCloudLogger::LOG_INFO, "[SaaS] Get config SaaS : #{params[:vm_name]}"
            oSaasManager = SaasManager.new(params)
            aResponse = oSaasManager.getConfig(params)
            (!aResponse == false) ? (sc_response aResponse) : (sc_response true)
          rescue ScError => e
            sc_response e
          end
        end
      end

    end
  end
end
