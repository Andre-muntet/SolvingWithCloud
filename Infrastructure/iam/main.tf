
resource "aws_iam_role" "ec2_s3_read" {
  name = "three-tier-ec2-s3-read-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.common_tags
}

resource "aws_iam_role_policy" "s3_read" {
  name = "three-tier-s3-read-policy"
  role = aws_iam_role.ec2_s3_read.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]

        Resource = [
          var.bucket_arn,
          "${var.bucket_arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2" {
  name = "three-tier-ec2-s3-read-profile"
  role = aws_iam_role.ec2_s3_read.name
}

resource "aws_iam_role" "backend" {
  name = "three-tier-backend-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.common_tags
}

resource "aws_iam_role_policy" "backend" {
  name = "three-tier-backend-policy"
  role = aws_iam_role.backend.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]

        Resource = [
          var.bucket_arn,
          "${var.bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = var.rds_secret_arn
      }
    ]
  })
}

resource "aws_iam_instance_profile" "backend" {
  name = "three-tier-backend-profile"
  role = aws_iam_role.backend.name
}


resource "aws_iam_user" "github_actions" {
  name = "three-tier-github-deploy"

  tags = var.common_tags
}

resource "aws_iam_policy" "github_actions" {
  name = "three-tier-github-s3-deploy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = var.bucket_arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "${var.bucket_arn}/*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "github_actions" {
  user       = aws_iam_user.github_actions.name
  policy_arn = aws_iam_policy.github_actions.arn
}