resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-sg-"
  description = "Security group for RDS instance"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Criação de um RDS PostgreSQL
resource "aws_db_instance" "postgres" {
  allocated_storage    = 10 
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "15.4" 
  instance_class       = "db.t3.micro" 
  db_name                 = "avalanches_producao_db" 
  username             = "dbadminuser" 
  password             = "securepassword" 
  parameter_group_name = "default.postgres15"
  skip_final_snapshot  = true
  publicly_accessible  = true 

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "rds_username" {
  value = aws_db_instance.postgres.username
}

output "rds_database_name" {
  value = aws_db_instance.postgres.db_name
}
