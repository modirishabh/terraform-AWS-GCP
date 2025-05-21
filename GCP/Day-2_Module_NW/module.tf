module "network" {
  source  = "terraform-google-modules/network/google"
  version = "1.1.0"
  network_name = "terraform-vpc-network"
  project_id   =  var.project

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     =  var.cidr
      subnet_region =  var.region
    },
  ]

  secondary_ranges = {
    subnet-01 = []
  }
}