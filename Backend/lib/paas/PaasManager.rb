#!/usr/bin/env ruby

require 'rconfig'

module SkyCloud
  autoload :IaasManager, "iaas/IaasManager"

  class PaasManager
    attr_reader :oVim

    def initialize aParams
      @sIp = IaasManager.new.get_ip(aParams)
    end

   def installPackages aParams
     SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[PaaS] Method install package"
     host = @sIp
     installMySQL(aParams)
     installSQLite(aParams)
     installApache(aParams)
     installPHP(aParams)
     installGit(aParams)
   end

   def installMySQL aParams
     SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[PaaS] Method install MySQL"
     host = @sIp
     ssh = Net::SSH.start(host, 'root')
     ssh.exec!("debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password #{aParams[:password]}'")
     ssh.exec!("debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password #{aParams[:password]}'")
     ssh.exec!("aptitude install mysql-server -y")
     ssh.close
   end

   def installSQLite aParams
     SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[PaaS] Method install SQLite"
     host = @sIp
     ssh = Net::SSH.start(host, 'root')
     ssh.exec!("aptitude install sqlite3 -y")
     ssh.close
   end

   def installApache aParams
     SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[PaaS] Method install Apache"
     host = @sIp
     ssh = Net::SSH.start(host, 'root')
     ssh.exec!("aptitude install apache2 -y")
     ssh.close
   end

   def installPHP aParams
     SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[PaaS] Method install PHP"
     host = @sIp
     ssh = Net::SSH.start(host, 'root')
     ssh.exec!("aptitude install php5-mysql php5-sqlite -y")
     ssh.close
   end

   def installGit aParams
     SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[PaaS] Method install Git"
     host = @sIp
     ssh = Net::SSH.start(host, 'root')
     ssh.exec!("aptitude install git -y")
     ssh.close
   end

   def gitClone aParams
     SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[PaaS] Method git clone repository"
     host = @sIp
     ssh = Net::SSH.start(host, 'root')
     ssh.exec!("mkdir -p /var/www/#{aParams[:application]}")
     ssh.exec!("git clone git://#{aParams[:repository]} /var/www/#{aParams[:application]}")
     ssh.close
   end

   def gitPull aParams
     SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[PaaS] Method git pull repository"
     host = @sIp
     ssh = Net::SSH.start(host, 'root')
     ssh.exec!("cd /var/www/#{aParams[:application]} && git pull")
     ssh.close
   end

  end
end
