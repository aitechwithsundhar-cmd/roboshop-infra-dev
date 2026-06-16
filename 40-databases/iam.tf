resource "aws_iam_role" "mysql" {
  name = local.mysql_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    {
      name = local.mysql_role_name
    },
    local.common_tags
  )
}

resource "aws_iam_policy" "mysql" {
  name = local.mysql_policy_name
  policy = templatefile("${path.module}/mysql_iam_policy.json", {
    environment = var.environment
  })
}

resource "aws_iam_role_policy_attachment" "mysql" {
  role       = aws_iam_role.mysql.name
  policy_arn = aws_iam_policy.mysql.arn
}

resource "aws_iam_instance_profile" "mysql" {
  name = "${var.project}-${var.environment}-mysql"
  role = aws_iam_role.mysql.name
}