module "network" {
  source  = "terraform-google-modules/network/google"
  version = "1.1.0"
  network_name = "terraform-vpc-network"
  project_id   =

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     =
      subnet_region =
    },
  ]

  secondary_ranges = {
    subnet-01 = []
  }
