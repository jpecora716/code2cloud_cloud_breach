resource "aws_instance" "sandbox-server" {
  ami = "ami-08848247386f75e85"
    instance_type = "t2.micro"
    iam_instance_profile = "${aws_iam_instance_profile.code2cloud-ec2-instance-profile.name}"
    subnet_id = "${aws_subnet.code2cloud-public-subnet-1.id}"
    associate_public_ip_address = true
    private_ip = "10.10.10.104"
    vpc_security_group_ids = [
        "${aws_security_group.code2cloud-ec2-ssh-security-group.id}",
    ]
    key_name = "${aws_key_pair.code2cloud-ec2-key-pair.key_name}"
    root_block_device {
        volume_type = "gp2"
        volume_size = 60
        delete_on_termination = true
    }

    provisioner "file" {
      source = "scripts/sandbox.sh"
      destination = "/home/ubuntu/sandbox.sh"
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file(var.ssh-private-key-for-ec2)}"
        host = self.public_ip
      }
    }

    provisioner "file" {
      source = "scripts/initial_setup.sh"
      destination = "/home/ubuntu/initial_setup.sh"
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file(var.ssh-private-key-for-ec2)}"
        host = self.public_ip
      }
    }

    provisioner "remote-exec" {
      inline = [
        "chmod +x /home/ubuntu/initial_setup.sh",
        "/home/ubuntu/initial_setup.sh",
      ]
      connection {
          type = "ssh"
          user = "ubuntu"
          private_key = "${file(var.ssh-private-key-for-ec2)}"
          host = self.public_ip
      }
    }

    tags = {
        Name = "code2cloud-sandbox-ec2-${var.code2cloudid}"
        Stack = "${var.stack-name}"
        Scenario = "${var.scenario-name}"
    }
}

output "sandbox-server" {
  value = aws_instance.sandbox-server.public_ip
}