#!/usr/bin/env ruby

require 'rconfig'

module SkyCloud
  class SaasManager
    attr_reader :oVim

    def initilize
      @oVim = nil
    end

   def setup_owncloud aParams
     host = "#{aParams[:ip]}"
     user = "root"
     ssh = Net::SSH.start(host, user, :password => "aragorn")
     #ssh.exec!("wget http://download.opensuse.org/repositories/isv:ownCloud:community/Debian_7.0/Release.key")
     #ssh.exec!("apt-key add - < Release.key")
     #ssh.exec!("rm Release.key")
     #ssh.exec!("echo 'deb http://download.opensuse.org/repositories/isv:ownCloud:community/Debian_7.0/ /' >> /etc/apt/sources.list.d/owncloud.list")
     #ssh.exec!("aptitude update")
     #ssh.exec!("aptitude install owncloud -y")
     cmd = "mysql -u root -pVirtualizeMe42 -e 'CREATE USER 'owncloud'@'localhost' IDENTIFIED BY "OwnCloud42";'"
     res = ssh.exec!(cmd)
     puts res
     ssh.exec!("mysql -u root -pVirtualizeMe42 -e 'CREATE DATABASE IF NOT EXISTS owncloud;'")
     cmd = "mysql -u root -pVirtualizeMe42 -e 'GRANT ALL PRIVILEGES ON owncloud.* TO 'owncloud'@'localhost' IDENTIFIED BY OwnCloud42;'"
     ssh.exec!(cmd)
     ssh.close
   end

  end
end
