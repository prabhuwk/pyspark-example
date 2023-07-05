provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "aaj-terraform-backend-s3"
    key    = "terraform-state/data_migration_services"
    region = "eu-west-1"
  }
}

resource "aws_security_group" "dms" {
  name        = "allow_dms"
  description = "Allow dms inbound traffic"
  vpc_id      = "vpc-041ab3e5f3baa8bb6"

  ingress {
    description      = "allow all"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_dms_replication_subnet_group" "aaj_dms_subnet_group" {
  replication_subnet_group_description = "DMS replication subnet group"
  replication_subnet_group_id          = "aaj-dms-replication-subnet-group"
  subnet_ids                           = ["subnet-06196c1b36da966aa", "subnet-04ef772386452bc19", "subnet-00f2eec36037a8a27"]
}

resource "aws_dms_replication_instance" "aaj_dms" {
  allocated_storage            = 10
  apply_immediately            = true
  auto_minor_version_upgrade   = true
  engine_version               = "3.4.7"
  multi_az                     = false
  publicly_accessible          = false
  replication_instance_class   = "dms.t3.micro"
  replication_instance_id      = "aaj-dms-replication-instance-01"
  replication_subnet_group_id  = aws_dms_replication_subnet_group.aaj_dms_subnet_group.id
  vpc_security_group_ids       = [aws_security_group.dms.id]

  depends_on = [aws_security_group.dms, aws_dms_replication_subnet_group.aaj_dms_subnet_group]
}
