#!/usr/bin/env ruby

require 'rbvmomi'

config = {
  :host => "192.168.254.254",
  :user => "group02",
  :password => "ndl)%Cg3",
  :insecure => "USE_INSECURE_SSL"
}

vim = RbVmomi::VIM.connect config
dcname = "datacenter-12"
dc = vim.serviceInstance.find_datacenter() or fail "DataCenter not found"

#vm = dc.vmFolder.childEntity.grep(RbVmomi::VIM::VirtualMachine).find do |x|
#puts x.name
#puts x.summary.config.memorySizeMB
#puts x.summary.config.numCpu
#puts x.summary.config.numEthernetCards
#puts x.summary.config.numVirtualDisks
#end

vm = dc.find_vm("vm-template-debian") or fail "VM not found"
p "Name : #{vm.name}"
p "Memory : #{vm.summary.config.memorySizeMB}"
p "CPU : #{vm.summary.config.numCpu}"
p "Eth : #{vm.summary.config.numEthernetCards}"
p "Disk : #{vm.summary.config.numVirtualDisks}"

p vm.methods
#p vm.config


vim.close

