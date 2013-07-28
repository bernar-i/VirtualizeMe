#!/usr/bin/env ruby

module SkyCloudError

  ##################
  # GENERAL ERRORS #
  ##################
	ERROR_10000     = -10000
  ERROR_MSG_10000 = "Unknown Error"

  ##################
  # MANAGER ERRORS #
  ##################

  ERROR_10100     = -10100
  ERROR_MSG_10100 = "Manager authentication not configured"

  ERROR_10101     = -10101
  ERROR_MSG_10101 = "Error during OpenNebula Client initialization"

  ERROR_10102     = -10102
  ERROR_MSG_10102 = "Error during manager authentication configuration"

  #########################
  # MANAGER SYSTEM ERRORS #
  #########################

  ERROR_10200     = -10200
  ERROR_MSG_10200 = "OpenNebula user system not configured"

  ERROR_10201     = -10201
  ERROR_MSG_10201 = "OpenNebula user system authentication failed"

  ERROR_10202     = -10202
  ERROR_MSG_10202 = "Error during OpenNebula user system configuration"

  ######################
  # HYPERVISORS ERRORS #
  ######################

  ERROR_10300     = -10300
  ERROR_MSG_10300 = "Error during OpenNebula Host initialization"

  ERROR_10301     = -10301
  ERROR_MSG_10301 = "Error when creating OpenNebula Host"

  ERROR_10302     = -10302
  ERROR_MSG_10302 = "Error when deleting OpenNebula Host"

  ERROR_10303     = -10303
  ERROR_MSG_10303 = "Hypervisor not found"

  ERROR_10304     = -10304
  ERROR_MSG_10304 = "Unable to return informations of hypervisor"

  ERROR_10305     = -10305
  ERROR_MSG_10305 = "Unable to return the state of hypervisor"

  #####################
  # DATASTORES ERRORS #
  #####################

  ERROR_10400     = -10400
  ERROR_MSG_10400 = "Error during OpenNebula DataStore initialization"

  ERROR_10401     = -10401
  ERROR_MSG_10401 = "Error when creating OpenNebula Datastore"

  ERROR_10402     = -10402
  ERROR_MSG_10402 = "Error when deleting OpenNebula Datastore"

  ERROR_10403     = -10403
  ERROR_MSG_10403 = "OpenNebula Datastore not found"

  #################
  # IMAGES ERRORS #
  #################

  ERROR_10500     = -10500
  ERROR_MSG_10500 = "Error during OpenNebula Image initialization"

  ERROR_10501     = -10501
  ERROR_MSG_10501 = "Error when creating OpenNebula Image"

  ERROR_10502     = -10502
  ERROR_MSG_10502 = "Error when deleting OpenNebula Image"

  ERROR_10503     = -10503
  ERROR_MSG_10503 = "OpenNebula Image not found"

  ERROR_10504     = -10504
  ERROR_MSG_10504 = "Unable to return the state of Image"

  ERROR_10505     = -10505
  ERROR_MSG_10505 = "Unable to return the type of Image"

  ###########################
  # VIRTUAL MACHINES ERRORS #
  ###########################

  ERROR_10600     = -10600
  ERROR_MSG_10600 = "Error during OpenNebula Virtual Machine initialization"

  ERROR_10601     = -10601
  ERROR_MSG_10601 = "Error when creating OpenNebula Virtual Machine"

  ERROR_10602     = -10602
  ERROR_MSG_10602 = "Error when deleting OpenNebula Virtual Machine"

  ERROR_10603     = -10603
  ERROR_MSG_10603 = "OpenNebula Virtual Machine not found"

  ERROR_10604     = -10604
  ERROR_MSG_10604 = "Unable to return the state of Virtual Machine"

  ERROR_10605     = -10605
  ERROR_MSG_10605 = "Unable to change the state of Virtual Machine"

end