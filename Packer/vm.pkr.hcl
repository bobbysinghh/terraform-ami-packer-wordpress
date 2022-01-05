variable "ami_id" {
  type    = string
  default = "ami-0fb653ca2d3203ac1"
}

variable "image_version" {
  type    = string
  default = "1"
}
variable "rds_db_name" {
  description = "Database name"
  type        = string

}
variable "rds_db_username" {
  description = "Database user"
  type        = string
}

variable "rds_db_user_password" {
  description = "Database Address"
  type        = string
}

variable "rds_address" {
  description = "Database Address"
  type        = string
}

source "amazon-ebs" "wordpress" {
  ami_name      = "wordpress-${var.image_version}"
  instance_type = "t2.micro"
  region        = "us-east-2"
  source_ami    = "${var.ami_id}"
  ssh_keypair_name = "bobby_devops"
  ssh_private_key_file = "./packer/bobby_devops.pem"
  ssh_username  = "ubuntu"
  run_tags = {
    Name = "Wordpress_${var.image_version}"  
  }
  tags = {
    Name = "Wordpress-${var.image_version}"
  }
}

build {
  sources = ["source.amazon-ebs.wordpress"]

  provisioner "ansible" {
      playbook_file = "setup.yml"
      inventory_file = "./inventory/"
      use_proxy= false
      ansible_env_vars= [
        "ANSIBLE_CONFIG=./packer/ansible.cfg" 
      ]
     extra_arguments = [
        "-e database_user=${var.rds_username}",
        "-e database=${var.rds_db_name}",
        "-e database_user_password=${var.rds_db_user_password}",
        "-e hostname=${var.rds_address}",
      ]

  }
}