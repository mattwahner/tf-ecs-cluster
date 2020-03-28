
data "aws_ami" "ecs_cluster_ami" {
    most_recent = true

    filter {
        name = "name"
        values = ["amzn-ami-*-amazon-ecs-optimized"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["amazon"]
}

data "template_file" "user_data" {
    template = file("${path.module}/user_data.sh")
    vars = {
        ecs_cluster = aws_ecs_cluster.ecs_cluster.name
    }
}

resource "aws_launch_configuration" "ecs_cluster_launch_configuration" {
    name_prefix = "${var.name}-lc-"
    image_id = data.aws_ami.ecs_cluster_ami.id
    instance_type = "t2.micro"
    user_data = data.template_file.user_data.rendered
    iam_instance_profile = aws_iam_instance_profile.ecs_cluster_iam_profile.name
    associate_public_ip_address = true
    security_groups = [aws_security_group.ecs_cluster_security_group.id]

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "ecs_cluster_asg" {
    name = "${var.name}_ecs_cluster_asg"
    launch_configuration = aws_launch_configuration.ecs_cluster_launch_configuration.name
    min_size = 1
    max_size = 1
    vpc_zone_identifier = data.aws_subnet_ids.default_vpc_subnets.ids

    lifecycle {
        create_before_destroy = true
    }

    tags = [
        {
            key = "Name"
            value = "${var.name}_instance"
        }
    ]
}
