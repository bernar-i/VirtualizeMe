#!/usr/bin/env ruby

require 'rconfig'

module SkyCloud
  class PaasManager
    attr_reader :oVim

    def initilize
      @oVim = nil
    end

   def get_ip aParams
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[PaaS] Method get_ip"
      oRbVmomiManager = RbVmomiManager.new
      oVim = oRbVmomiManager.connect

      oVm = oVim.serviceInstance.find_datacenter.find_vm(aParams[:vm_name])

      ip = oVm.summary.guest.ipAddress

      oRbVmomiManager.close

      return ip
   end

   def configure aParams
     SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[PaaS] Method configure"
     host =  get_ip(aParams)
     ssh = Net::SSH.start(host, 'root')
     ssh.exec!("debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password #{aParams[:password]}'")
     ssh.exec!("debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password #{aParams[:password]}'")
     ssh.exec!("aptitude install mysql-server -y")
     ssh.exec!("aptitude install apache2 php5-mysql php5-sqlite sqlite3 -y")
     ssh.exec!("aptitude install git -y")
     ssh.close
   end

  end
end
