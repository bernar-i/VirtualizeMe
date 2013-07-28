#!/usr/bin/env ruby

require 'rconfig'

module SkyCloud
  class IaasManager
    attr_reader :oVim

    def initialize
      @oVim = nil
    end

    def cloneVm aParams
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[IaaS] Method cloneVm"
      oRbVmomiManager = RbVmomiManager.new
      oVim = oRbVmomiManager.connect

      oVm = oVim.serviceInstance.find_datacenter.find_vm(aParams[:template])

      relocateSpec = RbVmomi::VIM.VirtualMachineRelocateSpec
      spec = RbVmomi::VIM.VirtualMachineCloneSpec(:location => relocateSpec, :powerOn => true, :template => false)

      oVm.CloneVM_Task(:folder => oVm.parent, :name => aParams[:vm_name], :spec => spec).wait_for_completion

      oRbVmomiManager.close
    end

    def virtualMachines
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[IaaS] Method virtualMachines"
      oRbVmomiManager = RbVmomiManager.new
      oVim = oRbVmomiManager.connect
      oDc = oVim.serviceInstance.find_datacenter

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

      oRbVmomiManager.close
      aResponseVm
    end

    def deleteVm sVm
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[IaaS] Method deleteVm"
      oRbVmomiManager = RbVmomiManager.new
      oVim = oRbVmomiManager.connect

      oVm = oVim.serviceInstance.find_datacenter.find_vm(sVm)
      oVm.Destroy_Task()

      oRbVmomiManager.close
    end

    def powerOn sVm
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[IaaS] Method powerOn"
      oRbVmomiManager = RbVmomiManager.new
      oVim = oRbVmomiManager.connect

      oVm = oVim.serviceInstance.find_datacenter.find_vm(sVm)
      oVm.PowerOnVM_Task.wait_for_completion

      oRbVmomiManager.close
    end

    def powerOff sVm
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[IaaS] Method powerOff"
      oRbVmomiManager = RbVmomiManager.new
      oVim = oRbVmomiManager.connect

      oVm = oVim.serviceInstance.find_datacenter.find_vm(sVm)
      oVm.PowerOffVM_Task.wait_for_completion

      oRbVmomiManager.close
    end

    def shutdown sVm
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[IaaS] Method shutdown"
      oRbVmomiManager = RbVmomiManager.new
      oVim = oRbVmomiManager.connect

      oVm = oVim.serviceInstance.find_datacenter.find_vm(sVm)
      oVm.ShutdownGuest

      oRbVmomiManager.close
    end

    def reboot sVm
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[IaaS] Method reboot"
      oRbVmomiManager = RbVmomiManager.new
      oVim = oRbVmomiManager.connect

      oVm = oVim.serviceInstance.find_datacenter.find_vm(sVm)
      oVm.RebootGuest

      oRbVmomiManager.close
    end

   def hostname aParams
     begin
       SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[IaaS] Method hostname"
       ssh = Net::SSH.start('192.168.202.100', 'root')
       ssh.exec!("sed -i 's/vm-debian-template/#{aParams[:vm_name]}/g' /etc/hostname")
       ssh.exec!('/etc/init.d/hostname.sh')
       ssh.close
     rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
       puts "The virtual machine #{aParams[:vm_name]} is still booting"
       sleep(1)
       retry
     end
   end

   def network aParams
     SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[IaaS] Method network"
     ssh = Net::SSH.start('192.168.202.100', 'root')
     ssh.exec!("sed -i 's/192.168.202.100/#{aParams[:ip]}/g' /etc/network/interfaces")
     ssh.close
     reboot(aParams[:vm_name])
   end

   def user aParams
     SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[IaaS] Method user"
     ssh = Net::SSH.start('192.168.202.100', 'root')
      ssh.exec!("useradd -m -s /bin/bash #{aParams[:login]} -p `mkpasswd #{aParams[:password]}`")
     ssh.close
   end

  end
end
