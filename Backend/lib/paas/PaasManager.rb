#!/usr/bin/env ruby

require 'rconfig'
require 'yaml'

module SkyCloud
  autoload :IaasManager, "iaas/IaasManager"

  class PaasManager
    attr_reader :sIp, :sPassword

    def initialize aParams
      begin
        aParams[:password_mysql].nil? ? @sPassword = "VirtualizeMe42!" : @sPassword = aParams[:password_mysql]
      rescue
        SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_FATAL, "[PaaS] Error to initalize PaasManager"
      end
    end

    def installPackages aParams, sIp
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[PaaS] Method installPackages"
      installPackage(aParams, "mysql-server", sIp)
      installPackage(aParams, "sqlite3", sIp)
      installPackage(aParams, "apache2", sIp)
      installPackage(aParams, "php5-mysql", sIp)
      installPackage(aParams, "php5-sqlite", sIp)
      installPackage(aParams, "git", sIp)
      setYml(aParams, sIp)
    end

    def installPackage aParams, sPackage, sIp
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[PaaS] Method installPackage : #{sPackage}"
      ssh = Net::SSH.start(sIp, 'root')
      if sPackage == "mysql-server"
        ssh.exec!("debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password #{@sPassword}'")
        ssh.exec!("debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password #{@sPassword}'")
      end
      ssh.exec!("aptitude install #{sPackage} -y")
      ssh.close
    end

    def setYml aParams, sIp
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[PaaS] Method setYml"
      hData = {}
      hData = {
        "package" => {
          "mysql-server" => "installed", 
          "php5-mysql" => "installed", 
          "php5-sqlite" => "installed",
          "sqlite3" => "installed",
          "apache2" => "installed",
          "git" => "installed"
        },
        "mysql_password" => @sPassword
      }
      if !aParams[:application].nil?
        hData[aParams[:application]] = { 
          "url" => "http://#{sIp}/#{aParams[:application]}",
          "git" => aParams[:repository]
        }
      end
      File.open("./config/#{aParams[:vm_name]}_paas.yml", "w") { |f|
        f.write(hData.to_yaml)
      }
    end

    def gitClone aParams, sIp
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[PaaS] Method git clone repository"
      ssh = Net::SSH.start(sIp, 'root')
      ssh.exec!("git clone #{aParams[:repository]} /var/www/#{aParams[:application]}")
      ssh.exec!("chown -R www-data:www-data /var/www/#{aParams[:application]}")
      ssh.close
    end

    def gitPull aParams, sIp
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[PaaS] Method git pull repository"
      ssh = Net::SSH.start(sIp, 'root')
      ssh.exec!("cd /var/www/#{aParams[:application]} && git pull")
      ssh.close
    end

    def getConfig aParams
      SkyCloud::ScLogger.instance.putLog SkyCloudLogger::LOG_DEBUG, "[PaaS] Method getConfig"
      sYml = "config/#{aParams[:vm_name]}_paas.yml"
      if File.exist?(sYml)
        YAML.load(File.open(sYml))
      else
        false
      end
    end

  end
end
