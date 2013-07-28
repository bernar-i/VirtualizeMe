 #!/usr/bin/env ruby

module SkyCloud
  autoload :ManagerSQL,  "provisioning/opennebula/ManagerSQL"
  autoload :ManagerON,   "provisioning/opennebula/ManagerON"
  
  module SkyCloudHelpers
    #def sc_connect
    #  adapter = format("%s://%s:%s@%s/%s",
    #          RConfig.database.manager.adapter,
    #          RConfig.database.manager.user,
    #          RConfig.database.manager.password,
    #          RConfig.database.manager.hostname,
    #          RConfig.database.manager.db_name)
  
    #  DataMapper::Model.raise_on_save_failure = true
    #  DataMapper::Logger.new(STDOUT, :debug)
    #  DataMapper.setup :default, adapter
    #end
    
    #def sc_opennebula
    #  oManON = ManagerON.new
    #  begin
    #    oClient = oManON.connect
    #    return oClient   
    #  end
    #end
  
    def is_authenticate
      #      env['HTTP_SECRET_PASSWORD'] == 'test'
    end
  
    def sc_authenticate!
      error!('401 Unauthorized', 401) unless is_authenticate
    end
  
    def sc_response mResponse = nil
      if (mResponse.nil?)
        oReturn = SkyCloud::ScRequest.new(false, SkyCloud::ScError.new(SkyCloudError::ERROR_10000, SkyCloudError::ERROR_MSG_10000))
      else
        if (mResponse.kind_of? SkyCloud::ScError)
          oReturn = SkyCloud::ScRequest.new(false, mResponse)
        else
          if mResponse.is_a?(FalseClass) || mResponse.is_a?(TrueClass)
            oReturn = SkyCloud::ScRequest.new(true)
          else
            oReturn = SkyCloud::ScRequest.new(true, mResponse)
          end
        end
      end
      return oReturn.toString
    end
  
    def sc_initialize
  #    SkyCloud::ScLogger.instance.initialize
    end
  
    def sc_log sLvl, sMsg
      SkyCloud::ScLogger.instance.putLog sLvl, sMsg
    end
  end
end
