#!/usr/bin/env ruby

require 'rconfig'

module SkyCloud
  class IaasManager
    attr_reader :oVim

    def initialize
      @oVim = nil
    end

    def get_ip aParams
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[IaaS] Method get_ip"
      sIp = nil
      oRbVmomiManager = RbVmomiManager.new
      oVim = oRbVmomiManager.connect
      oVm = oVim.serviceInstance.find_datacenter.find_vm(aParams[:vm_name])

      if (!oVm.nil? && oVm.summary.runtime.powerState == "poweredOn")
        for i in 1..30
          sIp = oVm.summary.guest.ipAddress
          if !sIp.nil?
            break
          end
          sleep(5)
        end
      end

      oRbVmomiManager.close

      return sIp
    end

    def cloneVm aParams
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[IaaS] Method cloneVm"
      oRbVmomiManager = RbVmomiManager.new
      oVim = oRbVmomiManager.connect

      oVm = oVim.serviceInstance.find_datacenter.find_vm(aParams[:template])

      if !oVm.nil?
        relocateSpec = RbVmomi::VIM.VirtualMachineRelocateSpec
        spec = RbVmomi::VIM.VirtualMachineCloneSpec(:location => relocateSpec, :powerOn => true, :template => false)

        oVm.CloneVM_Task(:folder => oVm.parent, :name => aParams[:vm_name], :spec => spec).wait_for_completion
      end

      oRbVmomiManager.close
    end

    def virtualMachines
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[IaaS] Method virtualMachines"
      oRbVmomiManager = RbVmomiManager.new
      oVim = oRbVmomiManager.connect
      oDc = oVim.serviceInstance.find_datacenter

      if !oDc.nil?
        aResponseVm = []
        oDc.vmFolder.childEntity.grep(RbVmomi::VIM::VirtualMachine).find do |vm|
          aResponseVm << {
            'name' => vm.name,
            'os' => vm.summary.config.guestFullName,
            'memoryMB' => vm.summary.config.memorySizeMB,
            'cpu' => vm.summary.config.numCpu,
            'network interface' => vm.summary.config.numEthernetCards,
            'ip' => vm.summary.guest.ipAddress,
            'vdisk' => vm.summary.config.numVirtualDisks,
            'state' => vm.summary.runtime.powerState,
            'uptime' => vm.summary.runtime.bootTime
          }
          puts vm
        end
      end

      oRbVmomiManager.close
      aResponseVm
    end

    def deleteVm sVm
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[IaaS] Method deleteVm"
      oRbVmomiManager = RbVmomiManager.new
      oVim = oRbVmomiManager.connect

      oVm = oVim.serviceInstance.find_datacenter.find_vm(sVm)
      if !oVm.nil?
        oVm.Destroy_Task()

        sYml = "config/#{sVm}_paas.yml"
        if File.exist?(sYml)
          File.delete(sYml)
        end

        sYml = "config/#{sVm}_saas.yml"
        if File.exist?(sYml)
          File.delete(sYml)
        end
      end

      oRbVmomiManager.close
    end

    def powerOn sVm
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[IaaS] Method powerOn"
      oRbVmomiManager = RbVmomiManager.new
      oVim = oRbVmomiManager.connect

      oVm = oVim.serviceInstance.find_datacenter.find_vm(sVm)
      if !oVm.nil?
        oVm.PowerOnVM_Task.wait_for_completion
      end

      oRbVmomiManager.close
    end

    def powerOff sVm
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[IaaS] Method powerOff"
      oRbVmomiManager = RbVmomiManager.new
      oVim = oRbVmomiManager.connect

      oVm = oVim.serviceInstance.find_datacenter.find_vm(sVm)
      if !oVm.nil?
        oVm.PowerOffVM_Task.wait_for_completion
      end

      oRbVmomiManager.close
    end

    def shutdown sVm
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[IaaS] Method shutdown"
      oRbVmomiManager = RbVmomiManager.new
      oVim = oRbVmomiManager.connect

      oVm = oVim.serviceInstance.find_datacenter.find_vm(sVm)
      if !oVm.nil?
        oVm.ShutdownGuest
      end

      oRbVmomiManager.close
    end

    def reboot sVm
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[IaaS] Method reboot"
      oRbVmomiManager = RbVmomiManager.new
      oVim = oRbVmomiManager.connect

      oVm = oVim.serviceInstance.find_datacenter.find_vm(sVm)
      if !oVm.nil?
        oVm.RebootGuest
      end

      oRbVmomiManager.close
    end

   def hostname aParams
     SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[IaaS] Method hostname"
     sIp = get_ip(aParams)
     ssh = Net::SSH.start(sIp, 'root')
     ssh.exec!("sed -i 's/#{aParams[:template]}/#{aParams[:vm_name]}/g' /etc/hostname")
     ssh.exec!('/etc/init.d/hostname.sh')
     ssh.close
   end

   def network aParams
     SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[IaaS] Method network"
     sIp = get_ip(aParams)
     ssh = Net::SSH.start(sIp, 'root')
     ssh.exec!("sed -i 's/#{sIp}/#{aParams[:ip]}/g' /etc/network/interfaces")
     ssh.close
     reboot(aParams[:vm_name])
   end

   def user aParams
     SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[IaaS] Method user"
     sIp = get_ip(aParams)
     ssh = Net::SSH.start(sIp, 'root')
      ssh.exec!("useradd -m -s /bin/bash #{aParams[:login]} -p `mkpasswd #{aParams[:password]}`")
     ssh.close
   end

 end
end
