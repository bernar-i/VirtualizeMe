#!/usr/bin/env ruby

require 'rconfig'
require 'yaml'

module SkyCloud
  autoload :IaasManager, "iaas/IaasManager"
  autoload :PaasManager, "paas/PaasManager"

  class SaasManager
    attr_reader :sIp, :sPassword

    def initialize aParams
      begin
        @sPassword = nil
        sYml = "config/#{aParams[:vm_name]}_paas.yml"
        if File.exist?(sYml)
          sFile = YAML.load(File.open(sYml))
          @sPassword = sFile["mysql_password"]
        end
      rescue
        SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_FATAL, "[SaaS] Error to initalize SaasManager"
      end
    end

   def configureOwncloud aParams, sIp
     if @sPassword.nil?
       paas = PaasManager.new(aParams)
       paas.installPackage(aParams, "mysql-server", sIp)
       @sPassword = "VirtualizeMe42!"
     end
     SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[SaaS] Method configureOwncloud"
     ssh = Net::SSH.start(sIp, 'root')
     ssh.exec!("wget http://download.opensuse.org/repositories/isv:ownCloud:community/Debian_7.0/Release.key")
     ssh.exec!("apt-key add - < Release.key")
     ssh.exec!("rm Release.key")
     ssh.exec!("echo 'deb http://download.opensuse.org/repositories/isv:ownCloud:community/Debian_7.0/ /' >> /etc/apt/sources.list.d/owncloud.list")
     ssh.exec!("aptitude update")
     ssh.exec!("aptitude install owncloud -y")
     ssh.exec!("mysql -u root -p\"#{@sPassword}\" -e 'CREATE USER 'owncloud'@'localhost' IDENTIFIED BY \"OwnCloud42\";'")
     ssh.exec!("mysql -u root -p\"#{@sPassword}\" -e 'CREATE DATABASE IF NOT EXISTS owncloud;'")
     ssh.exec!("mysql -u root -p\"#{@sPassword}\" -e 'GRANT ALL PRIVILEGES ON owncloud.* TO 'owncloud'@'localhost' IDENTIFIED BY \"OwnCloud42\";'")
     ssh.exec!("echo '<?php' > /var/www/owncloud/config/autoconfig.php")
     ssh.exec!("echo '$AUTOCONFIG = array(' >> /var/www/owncloud/config/autoconfig.php")
     ssh.exec!("echo '  \"dbtype\"        => \"mysql\",' >> /var/www/owncloud/config/autoconfig.php")
     ssh.exec!("echo '  \"dbname\"        => \"owncloud\",' >> /var/www/owncloud/config/autoconfig.php")
     ssh.exec!("echo '  \"dbuser\"        => \"owncloud\",' >> /var/www/owncloud/config/autoconfig.php")
     ssh.exec!("echo '  \"dbpass\"        => \"OwnCloud42\",' >> /var/www/owncloud/config/autoconfig.php")
     ssh.exec!("echo '  \"dbhost\"        => \"localhost\",' >> /var/www/owncloud/config/autoconfig.php")
     ssh.exec!("echo '  \"dbtableprefix\" => \"\",' >> /var/www/owncloud/config/autoconfig.php")
     ssh.exec!("echo '  \"adminlogin\"    => \"#{aParams[:username]}\",' >> /var/www/owncloud/config/autoconfig.php")
     ssh.exec!("echo '  \"adminpass\"     => \"#{aParams[:password]}\",' >> /var/www/owncloud/config/autoconfig.php")
     ssh.exec!("echo '  \"directory\"     => \"/var/www/owncloud/data\",' >> /var/www/owncloud/config/autoconfig.php")
     ssh.exec!("echo ');' >> /var/www/owncloud/config/autoconfig.php")
   end

   def user aParams, sIp
     if @sPassword.nil?
       @sPassword = "VirtualizeMe42!"
     end
     SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[SaaS] Method user"
     ssh = Net::SSH.start(sIp, 'root')
     password = Digest::SHA1.hexdigest "#{aParams[:password]}"
     res = ssh.exec!("mysql -u root -p#{@sPassword} -e 'INSERT INTO owncloud.users (uid,password) values(\"#{aParams[:username]}\",\"#{password}\");'")
   end

    def setYml aParams, sIp
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[SaaS] Method setYml"
      hData = {}
      hData = {
        "ownCloud" => {
          "url" => "http://#{sIp}/owncloud"
        }
      }
      hData[aParams[:username]] = {
        "password" => aParams[:password]
      }
      File.open("config/#{aParams[:vm_name]}_saas.yml", "w") { |f|
        f.write(hData.to_yaml)
      }
    end

    def getConfig aParams
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[SaaS] Method getConfig"
      sYml = "config/#{aParams[:vm_name]}_saas.yml"
      if File.exist?(sYml)
        YAML.load(File.open(sYml))
      else
        false
      end
    end
  
  end
end
