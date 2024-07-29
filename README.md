# MultiOsPackerBuildVm
You can create the vm of your choice by tapping this command for example (for rbuilding RHEL 8.10 VM)
 packer build -only="virtualbox-iso.rhel8" -var-file=".auto.pkrvars.hcl" -var 'output_directory=output1/rhel8.10' -var 'vm_name=rhel8.10-6' unified.pkr.hcl      
