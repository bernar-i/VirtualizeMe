#!/usr/bin/env ruby

require 'rbvmomi'
require 'net/ssh'
include Net

module SkyCloud
  autoload :IaasManager, "iaas/IaasManager"
  autoload :RbVmomiManager, "rbvmomi/RbVmomiManager"

  class IaasController < Grape::API
    namespace :iaas do
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

      desc "Clone a Virtual Machine on a ESXi hypervisor"
      namespace 'clone' do
        desc ""
        params do
          requires :template, :type => String, :desc => ""
          requires :vm_name, :type => String, :desc => ""
        end
        post do
          begin
            sc_log SkyCloudLogger::LOG_INFO, "[IaaS] Start clone virtual machine"
            oIaasManager = IaasManager.new
            oIaasManager.cloneVm(params)
            for i in 1..60
              sIp = PaasManager.new.get_ip(params)
              if !sIp.nil?
                break
              end
              sleep(5)
            end
            if !sIp.nil?
              oIaasManager.hostname(params)
              oIaasManager.user(params)
              oIaasManager.network(params)
            end
            sc_response true
          rescue ScError => e
            sc_response e
          end
        end
      end

      desc "Get the virtual machines list on a ESXi hypervisor"
      namespace 'virtual_machines' do
        desc ""
        get do
          begin
            sc_log SkyCloudLogger::LOG_INFO, "[IaaS] Get the virtual machines list"
            aResponse = IaasManager.new.virtualMachines()
            sc_response aResponse
          rescue ScError => e
            sc_response e
          end
        end
      end

      desc "Delete a Virtual Machine on a ESXi hypervisor"
      namespace ':vm_name' do
        desc ""
        delete do
          begin
            sc_log SkyCloudLogger::LOG_INFO, "[IaaS] Delete virtual machine : #{params[:vm_name]}"
            IaasManager.new.deleteVm(params[:vm_name])
            sc_response true
          rescue ScError => e
            sc_response e
          end
        end

        desc "Power On a Virtual Machine on a ESXi hypervisor"
        namespace 'poweron' do
          desc ""
          post do
            begin
              sc_log SkyCloudLogger::LOG_INFO, "[IaaS] Power On virtual machine : #{params[:vm_name]}"
              IaasManager.new.powerOn(params[:vm_name])
              sc_response true
            rescue ScError => e
              sc_response e
            end
          end
        end

        desc "Power off a Virtual Machine on a ESXi hypervisor"
        namespace 'poweroff' do
          desc ""
          post do
            begin
              sc_log SkyCloudLogger::LOG_INFO, "[IaaS] Power Off virtual machine : #{params[:vm_name]}"
              oIaasManager = IaasManager.new.powerOff(params[:vm_name])
              sc_response true
            rescue ScError => e
              sc_response e
            end
          end
        end

        desc "Shutdown a Virtual Machine on a ESXi hypervisor"
        namespace 'shutdown' do
          desc ""
          post do
            begin
              sc_log SkyCloudLogger::LOG_INFO, "[IaaS] Shutdown virtual machine : #{params[:vm_name]}"
              oIaasManager = IaasManager.new.shutdown(params[:vm_name])
              sc_response true
            rescue ScError => e
              sc_response e
            end
          end
        end

        desc "Reboot a Virtual Machine on a ESXi hypervisor"
        namespace 'reboot' do
          desc ""
          post do
            begin
              sc_log SkyCloudLogger::LOG_INFO, "[IaaS] Reboot virtual machine : #{params[:vm_name]}"
              oIaasManager = IaasManager.new.reboot(params[:vm_name])
              sc_response true
            rescue ScError => e
              sc_response e
            end
          end
        end

        desc "Configure Virtual Machine hostname"
        namespace 'hostname' do
          desc ""
          params do
            requires :ip, :type => String, :desc => ""
          end
          post do
            begin
              sc_log SkyCloudLogger::LOG_INFO, "[IaaS] Configure #{params[:vm_name]} hostname"
              oIaasManager = IaasManager.new.hostname(params)
              sc_response true
            rescue ScError => e
              sc_response e
            end
          end
        end

        desc "Configure Virtual Machine network"
        namespace 'network' do
          desc ""
          params do
            requires :ip, :type => String, :desc => ""
          end
          post do
            begin
              sc_log SkyCloudLogger::LOG_INFO, "[IaaS] Configure #{params[:vm_name]} network"
              oIaasManager = IaasManager.new.network(params)
              sc_response true
            rescue ScError => e
              sc_response e
            end
          end
        end

        desc "Configure Virtual Machine user" 
        namespace 'user' do
          desc ""
          params do
            requires :ip, :type => String, :desc => ""
            requires :login, :type => String, :desc => ""
            requires :password, :type => String, :desc => ""
          end
          post do
            begin
              sc_log SkyCloudLogger::LOG_INFO, "[IaaS] Configure #{params[:vm_name]} user"
              oIaasManager = IaasManager.new.user(params)
              sc_response true
            rescue ScError => e
              sc_response e
            end
          end
        end

      end
    end
  end
end
