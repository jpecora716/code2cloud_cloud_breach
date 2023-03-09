resource "aws_iam_role" "code2cloud-admin-readonly-role" {
  name = "code2cloud-admin-readonly-role-${var.code2cloudid}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
      Name = "code2cloud-ec2-role-${var.code2cloudid}"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}

data "aws_iam_policy" "ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_policy_attachment" "code2cloud-admin-role-policy-attachment" {
  name = "code2cloud-admin-role-policy-attachment-${var.code2cloudid}"
  roles = [
      "${aws_iam_role.code2cloud-admin-readonly-role.name}"
  ]
  policy_arn = "${data.aws_iam_policy.ReadOnlyAccess.arn}"
}

resource "aws_iam_instance_profile" "code2cloud-admin" {
  name = "code2cloud-admin-${var.code2cloudid}"
  role = "${aws_iam_role.code2cloud-admin-readonly-role.name}"
}