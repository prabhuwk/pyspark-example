provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "aaj-terraform-backend-s3"
    key    = "postgres_rds"
    region = "eu-west-1"
  }
}

resource "aws_security_group" "rds" {
  name        = "allow_postgres"
  description = "Allow postgres inbound traffic"
  vpc_id      = "vpc-041ab3e5f3baa8bb6"

  ingress {
    description      = "allow postgres"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_db_parameter_group" "postgres14_pg" {
  name   = "aaj-postgres14-rds-cdc-parameter-group"
  family = "postgres14"

  parameter {
    name  = "rds.logical_replication"
    value = "1"
    apply_method = "pending-reboot"
  }
}

resource "aws_db_instance" "aaj-postgres-rds-cdc-01" {
  identifier             = "aaj-postgres-rds-cdc-01"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14"
  username               = "aajdba"
  password               = var.db_password
  db_subnet_group_name   = "default-vpc-041ab3e5f3baa8bb6"
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.postgres14_pg.name
  publicly_accessible    = true
  skip_final_snapshot    = true

  depends_on = [aws_security_group.rds, aws_db_parameter_group.postgres14_pg]
}