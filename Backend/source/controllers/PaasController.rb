#!/usr/bin/env ruby

require 'rbvmomi'

module SkyCloud
  autoload :PaasManager, "paas/PaasManager"

  class PaasController < Grape::API
    namespace :paas do
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

      desc "Configure a Virtual Machine on a ESXi hypervisor"
      namespace 'configure' do
        desc ""
        params do
          requires :vm_name, :type => String, :desc => ""
          requires :password, :type => String, :desc => ""
        end
        post do
          begin
            sc_log SkyCloudLogger::LOG_INFO, "[PaaS] Configure virtual machine"
            oPaasManager = PaasManager.new
            oPaasManager.configure(params)
            sc_response true
          rescue ScError => e
            sc_response e
          end
        end
      end

    end
  end
end
