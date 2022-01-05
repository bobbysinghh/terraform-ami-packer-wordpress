resource "null_resource" "packer_ami" {
  depends_on = [
    module.rds_mysql_instance
  ]
  provisioner "local-exec" {
    command = "packer build -force -var \"rds_db_name=${module.rds_mysql_instance.rds_initial_database_name}\" -var \"rds_db_username=${module.rds_mysql_instance.rds_database_username}\" -var \"rds_db_user_password=${module.rds_mysql_instance.rds_database_user_password}\" -var \"rds_address=${module.rds_mysql_instance.rds_address}\"  Packer/"
  }
}
