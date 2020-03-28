
data "aws_vpc" "default_vpc" {
    default = true
}

data "aws_subnet_ids" "default_vpc_subnets" {
    vpc_id = data.aws_vpc.default_vpc.id
}

resource "aws_security_group" "ecs_cluster_security_group" {
    name = "${var.name}_ecs_cluster_security_group"
    vpc_id = data.aws_vpc.default_vpc.id

    dynamic "ingress" {
        for_each = var.ports
        content {
            from_port = ingress.value
            to_port = ingress.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.name}_ecs_cluster_security_group"
    }
}
