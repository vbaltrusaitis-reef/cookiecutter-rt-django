resource "random_string" "random" {
  length           = 20
  special          = true
  override_special = "$."
}

resource "aws_db_subnet_group" "admin" {
  name       = "${var.name}-${var.env}"
  subnet_ids = var.subnets

  tags = {
    Project = var.name
    Env = var.env
    Name = "DB subnet group"
  }
}

resource "aws_db_instance" "admin" {
  identifier             = "${var.name}-${var.env}-db"
  allocated_storage      = 5
  max_allocated_storage  = 20
  storage_encrypted      = true
  engine                 = "postgres"
  instance_class         = "db.t3.small"
  username               = "master"
  db_name                = var.name
  password               = random_string.random.result
  skip_final_snapshot    = true
  availability_zone      = var.azs[0]
  db_subnet_group_name   = aws_db_subnet_group.admin.name
  vpc_security_group_ids = [aws_security_group.db.id]

  tags = {
    Project = var.name
  }
}
