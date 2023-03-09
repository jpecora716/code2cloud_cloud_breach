resource "aws_instance" "attacker-server" {
  ami = "ami-04e44beaf0514489b"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.code2cloud-public-subnet-1.id}"
    associate_public_ip_address = true
    vpc_security_group_ids = [
        "${aws_security_group.code2cloud-ec2-ssh-security-group.id}"
    ]
    key_name = "${aws_key_pair.code2cloud-ec2-key-pair.key_name}"
    root_block_device {
        volume_type = "gp2"
        volume_size = 60
        delete_on_termination = true
    }
    
    
    provisioner "file" {
      source = "scripts/exploit/exploit.py"
      destination = "/home/ubuntu/exploit.py"
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file(var.ssh-private-key-for-ec2)}"
        host = self.public_ip
        agent = "false"
      }
    }

    provisioner "file" {
      source = "scripts/exploit/aws_service_enum/aws_service_enum.py"
      destination = "/home/ubuntu/aws_service_enum.py"
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file(var.ssh-private-key-for-ec2)}"
        host = self.public_ip
      }
    }

    provisioner "file" {
      source = "scripts/exploit/aws_service_enum/commands_list.txt"
      destination = "/home/ubuntu/commands_list.txt"
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file(var.ssh-private-key-for-ec2)}"
        host = self.public_ip
      }
    }

    provisioner "file" {
      source = "scripts/exploit/requirements.txt"
      destination = "/home/ubuntu/requirements.txt"
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file(var.ssh-private-key-for-ec2)}"
        host = self.public_ip
      }
    }

    provisioner "remote-exec" {
      inline = [
        "sudo pip install -r requirements.txt",
        "sudo systemctl stop jenkins.service",
        "sudo apt remove awscli -y",
        "sudo pip3 install awscli",
        "sudo mv /usr/local/bin/aws /usr/bin/",
        "sudo apt install jq -y"
      ]
      connection {
          type = "ssh"
          user = "ubuntu"
          private_key = "${file(var.ssh-private-key-for-ec2)}"
          host = self.public_ip
      }
    }

    tags = {
        Name = "code2cloud-attacker-ec2-${var.code2cloudid}"
        Stack = "${var.stack-name}"
        Scenario = "${var.scenario-name}"
    }
}

output "attacker-server" {
  value = aws_instance.attacker-server.public_ip
}