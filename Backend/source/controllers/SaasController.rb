#!/usr/bin/env ruby

require 'rbvmomi'

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
          requires :ip, :type => String, :desc => ""
        end
        post do
          begin
            sc_log SkyCloudLogger::LOG_INFO, "[SaaS] Configure virtual machine"
            oSaasManager = SaasManager.new
            oSaasManager.setup_owncloud(params)
            sc_response true
          rescue ScError => e
            sc_response e
          end
        end
      end

    end
  end
end
