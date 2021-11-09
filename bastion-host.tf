resource "aws_instance" "anksagar-bastion-host" {
  ami = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  key_name = aws_key_pair.anksagarkey.key_name
  subnet_id = module.vpc.public_subnets[0]
  count = var.instance_count
  vpc_security_group_ids = [aws_security_group.anksagar-bastion-sg.id]

  tags = {
    Name = "anksagar-bastion-host"
    PROJECT = "anksagar"
  }

  provisioner "file" {
    content = templatefile("templates/db-deploy.tmpl", { rds-endpoint = aws_db_instance.anksagar-rds.address, dbuser = var.dbuser, dbpass = var.dbpass})
    destination = "/tmp/anksagar-dbdeploy.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/anksagar-dbdeploy.sh",
      "sudo /tmp/anksagar-dbdeploy.sh"
    ]
  }

  connection {
    user = var.USERNAME
    private_key = file(var.PRIV_KEY_PATH)
    host = self.public_ip
  }
}