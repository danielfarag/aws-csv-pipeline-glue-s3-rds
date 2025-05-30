resource "aws_iam_role" "glue_service_role" {
  name = "glue-crawler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",

        Principal = {
          Service = "glue.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "glue_s3_access" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonS3FullAccess" ,
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
  ])

  role       = aws_iam_role.glue_service_role.name
  policy_arn =  each.value
}

resource "aws_iam_role_policy" "glue_rds_access_policy" {
  name = "GlueRDSAccessPolicy"
  role = aws_iam_role.glue_service_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:AssignPrivateIpAddresses",
          "ec2:UnassignPrivateIpAddresses"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "rds:DescribeDBInstances" 
        ],
        Resource = "*"
      }
    ]
  })
}
