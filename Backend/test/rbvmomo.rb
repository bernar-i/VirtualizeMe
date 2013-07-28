#!/usr/bin/env ruby

require 'rbvmomi'

config = {
  :host => "192.168.1.200",
  :user => "root",
  :password => "E$xS3rv3r",
  :insecure => "USE_INSECURE_SSL"
}

vim = RbVmomi::VIM.connect config
dcname = "ha-datacenter"
dc = vim.serviceInstance.find_datacenter(dcname)
p dc.find_vm("CLT-ESX-CENTOS")
vim.close

