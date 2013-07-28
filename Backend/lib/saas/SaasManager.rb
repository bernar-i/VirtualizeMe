#!/usr/bin/env ruby

require 'rconfig'

module SkyCloud
  autoload :IaasManager, "iaas/IaasManager"

  class SaasManager
    attr_reader :oVim

    def initialize aParams
      @sIp = IaasManager.new.get_ip(aParams)
    end

   def configureOwncloud aParams
     SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[SaaS] Method configureOwncloud"
     ssh = Net::SSH.start(@sIp, 'root')
     ssh.exec!("wget http://download.opensuse.org/repositories/isv:ownCloud:community/Debian_7.0/Release.key")
     ssh.exec!("apt-key add - < Release.key")
     ssh.exec!("rm Release.key")
     ssh.exec!("echo 'deb http://download.opensuse.org/repositories/isv:ownCloud:community/Debian_7.0/ /' >> /etc/apt/sources.list.d/owncloud.list")
     ssh.exec!("aptitude update")
     ssh.exec!("aptitude install owncloud -y")
     ssh.exec!("mysql -u root -pVirtualizeMe42 -e 'CREATE USER 'owncloud'@'localhost' IDENTIFIED BY \"OwnCloud42\";'")
     ssh.exec!("mysql -u root -pVirtualizeMe42 -e 'CREATE DATABASE IF NOT EXISTS owncloud;'")
     ssh.exec!("mysql -u root -pVirtualizeMe42 -e 'GRANT ALL PRIVILEGES ON owncloud.* TO 'owncloud'@'localhost' IDENTIFIED BY \"OwnCloud42\";'")
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

   def user aParams
     SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[SaaS] Method user"
     ssh = Net::SSH.start(@sIp, 'root')
     password = Digest::SHA1.hexdigest "#{aParams[:password]}"
     res = ssh.exec!("mysql -u root -pVirtualizeMe42 -e 'INSERT INTO owncloud.users (uid,password) values(\"#{aParams[:username]}\",\"#{password}\");'")
   end

  end
end
