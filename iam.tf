
data "aws_iam_policy_document" "ecs_cluster_assume_role_policy" {
    statement {
        actions = ["sts:AssumeRole"]
        sid = ""
        effect = "Allow"

        principals {
            type = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "ecs_cluster_iam_role" {
    name = "${var.name}_ecs_cluster_iam_role"
    path = "/"
    assume_role_policy = data.aws_iam_policy_document.ecs_cluster_assume_role_policy.json
    tags = {
        Name = "${var.name}_ecs_cluster_iam_role"
    }
}

resource "aws_iam_role_policy_attachment" "ecs_cluster_policy" {
    role = aws_iam_role.ecs_cluster_iam_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_cluster_iam_profile" {
    name = "${var.name}_ecs_cluster_iam_profile"
    role = aws_iam_role.ecs_cluster_iam_role.name
}
