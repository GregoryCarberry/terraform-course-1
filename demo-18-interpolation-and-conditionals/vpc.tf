module "vpc-prod" {
  source  = "terraform-aws-modules/vpc/aws"
<<<<<<< HEAD:demo-18-interpolation-and-conditionals/vpc.tf
  # version = "2.59.0" 
  version = ">= 4.0.0"
=======
  version = "5.19.0"
>>>>>>> 2e06c8080b999f3d9d656a207b8af50dd947ce78:demo-18/vpc.tf

  name = "vpc-prod"
  cidr = "10.0.0.0/16"

  azs             = ["${var.AWS_REGION}a", "${var.AWS_REGION}b", "${var.AWS_REGION}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
}

module "vpc-dev" {
  source  = "terraform-aws-modules/vpc/aws"
<<<<<<< HEAD:demo-18-interpolation-and-conditionals/vpc.tf
  # version = "2.59.0"
  version = ">= 4.0.0"
  
=======
  version = "5.19.0"

>>>>>>> 2e06c8080b999f3d9d656a207b8af50dd947ce78:demo-18/vpc.tf
  name = "vpc-dev"
  cidr = "10.0.0.0/16"

  azs             = ["${var.AWS_REGION}a", "${var.AWS_REGION}b", "${var.AWS_REGION}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

