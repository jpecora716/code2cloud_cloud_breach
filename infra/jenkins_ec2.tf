resource "aws_instance" "jenkins-server" {
  ami = "ami-04e44beaf0514489b"
    instance_type = "t2.medium"
    subnet_id = "${aws_subnet.code2cloud-public-subnet-1.id}"
    associate_public_ip_address = true
    vpc_security_group_ids = [
        "${aws_security_group.code2cloud-ec2-ssh-security-group.id}",
        "${aws_security_group.code2cloud-ec2-http-security-group.id}"
    ]
    key_name = "${aws_key_pair.code2cloud-ec2-key-pair.key_name}"
    root_block_device {
        volume_type = "gp2"
        volume_size = 60
        delete_on_termination = true
    }

    tags = {
        Name = "code2cloud-jenkins-ec2-${var.code2cloudid}"
        Stack = "${var.stack-name}"
        Scenario = "${var.scenario-name}"
    }
}

output "jenkins-server" {
  value = aws_instance.jenkins-server.public_ip
}