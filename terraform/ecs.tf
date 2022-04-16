resource "aws_security_group" "ec2" {
  description = "security-group--ec2"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    from_port       = 0
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    to_port         = 65535
  }

  name = "security-group--ec2"

  tags = {
    Env  = "production"
    Name = "security-group--ec2"
  }

  vpc_id = aws_vpc.default.id
}

data "aws_iam_policy_document" "ecs" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "ecs" {
  assume_role_policy = data.aws_iam_policy_document.ecs.json
  name               = "ecsInstanceRole"
}

resource "aws_iam_role_policy_attachment" "ecs" {
  role       = aws_iam_role.ecs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs" {
  name = "ecsInstanceProfile"
  role = aws_iam_role.ecs.name
}

data "aws_ami" "default" {
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.202*-x86_64-ebs"]
  }

  most_recent = true
  owners      = ["amazon"]
}

resource "aws_launch_configuration" "default" {
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ecs.name
  image_id                    = data.aws_ami.default.id
  instance_type               = "t2.micro"
  #   key_name                    = "django-app"

  lifecycle {
    create_before_destroy = true
  }

  name_prefix = "lauch-configuration-"

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  security_groups = [aws_security_group.ec2.id]
  user_data       = file("user_data.sh")
}

resource "aws_autoscaling_group" "default" {
  desired_capacity     = 1
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.default.name
  max_size             = 2
  min_size             = 1
  name                 = "auto-scaling-group"

  tag {
    key                 = "Env"
    propagate_at_launch = true
    value               = "production"
  }

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "django-app"
  }

  target_group_arns    = [aws_alb_target_group.default.arn]
  termination_policies = ["OldestInstance"]

  vpc_zone_identifier = [
    aws_subnet.public__a.id,
    aws_subnet.public__b.id
  ]
}

resource "aws_ecr_repository" "default" {
  name = "django-app"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "repository_url" {
  value = aws_ecr_repository.default.repository_url
}

resource "aws_ecs_cluster" "production" {
  lifecycle {
    create_before_destroy = true
  }

  name = "production"

  tags = {
    Env  = "production"
    Name = "production"
  }
}

resource "aws_ecs_task_definition" "default" {
  container_definitions = jsonencode([
    {
      cpu = 512
      environment = [
        {
          "name" : "RDS_DB_NAME",
          "value" : "${var.rds_db_name}"
        },
        {
          "name" : "RDS_USERNAME",
          "value" : "${var.rds_username}"
        },
        {
          "name" : "RDS_PASSWORD",
          "value" : "${var.rds_password}"
        },
        {
          "name" : "RDS_HOSTNAME",
          "value" : "${aws_db_instance.default.address}"
        },
        {
          "name" : "RDS_PORT",
          "value" : "5432"
        }
      ],
      image  = "${aws_ecr_repository.default.repository_url}:latest",
      memory = 450,
      name   = "app",
      portMappings = [
        {
          containerPort = 8000,
          hostPort      = 0
        }
      ]
    }
  ])
  depends_on               = [aws_db_instance.default]
  family                   = "django-app"
  memory                   = 450
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
}

data "aws_ecs_task_definition" "default" {
  task_definition = aws_ecs_task_definition.default.family
}

resource "aws_ecs_service" "default" {
  cluster                 = aws_ecs_cluster.production.id
  depends_on              = [aws_iam_role_policy_attachment.ecs]
  desired_count           = 2
  enable_ecs_managed_tags = true
  force_new_deployment    = true

  load_balancer {
    target_group_arn = aws_alb_target_group.default.arn
    container_name   = "app"
    container_port   = 8000
  }

  name            = "django-app"
  task_definition = "${aws_ecs_task_definition.default.family}:${data.aws_ecs_task_definition.default.revision}"
}
