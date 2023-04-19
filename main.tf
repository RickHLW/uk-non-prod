terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.69.0"
    }
  }
}

provider "aws" {

  region  = "eu-west-1"
/*
  access_key = "ASIA4K5GK2MVCN2WO57L"
  secret_key = "Rs44Rj1StMen8MfX28A+LNBg5ppHDagqej329opr"
  token = "FwoGZXIvYXdzEKT//////////wEaDAKDFAwsXxa1JphT3iLrAWdEVb5xCB2H08TU5V4MTRMm80cbtEyVqB5qkyL3E+hzMdRmfWFwonlf0pnv1uT42ku6cf5YZMXPli2EQVX5D2biy8I7zaXtbsO8RLFQ/hfFYX6nihExf98Tf/Mu7TBW7rq7LxJedjiqUEeGhx1RvXcW3RQAR/3C8yweN1V8SJ+CkpZxDXEQvQeyQ2WpdWTqjNuLIA10LzGkHB2NDR0+i472kxIZZRmPY5d0+YPIxAL0amnAHEyjJp7JDq79F5LhcEH5QTGCpBvDHIUGrjzUjfjVtU+YyLtke8OqBmNszfSPGbGyAAphGDh3oi0on4PEkwYyK52Nl0xADRh/IoFCmvSHEmByxwb6oX6lqHsbMQiM1Mu3oJkT6OQ3yc8Rb14="
*/
} 


module "vimn_vpc" {

  source = "./modules/vpc"
  project_name = "Para_PoC_DNSServer_Migration"
  vpc_name = "vpc_PoC_DNS01"
  subnet_name = "subnet_PoC_DNS01"
  sg_name = "sg_PoC_DNS01"
  service_ports = [22,80,443]
  }

module "vimn_ec2" {
 
  source = "./modules/ec2"
  sg_used = ["${module.vimn_vpc.sgid}"]
  subnet_used = "${module.vimn_vpc.subnetid}"
  project_name = "Para_PoC_DNSServer_Migration"

}

module "vimn_elb" {
  
  source = "./modules/elb"
  project_name = "Para_PoC_DNSServer_Migration"
  elb_vpc = "${module.vimn_vpc.vpcid}"
  elb_sg = ["${module.vimn_vpc.sgid}"]
  elb_subnet = "${module.vimn_vpc.subnetid}"
  elb_subnet2 = "${module.vimn_vpc.subnetid2}"
  no_of_instance = length(module.vimn_ec2.EC2id)
  EC2list = "${module.vimn_ec2.EC2id}"
}
