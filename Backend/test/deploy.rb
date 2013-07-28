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
vm = vim.serviceInstance.find_datacenter.find_vm("CLT-ESX-DEBIAN")
VIM = RbVmomi::VIM
relocateSpec = RbVmomi::VIM.VirtualMachineRelocateSpec
spec = VIM.VirtualMachineCloneSpec(:location => relocateSpec, :powerOn => false, :template => false)

p vm

vm.CloneVM_Task(:folder => vm.parent, :name => "bla", :spec => spec).wait_for_completion
