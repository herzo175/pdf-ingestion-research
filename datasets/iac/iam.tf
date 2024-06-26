data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

data "aws_iam_policy_document" "bedrock_access" {
  statement {
    effect = "Allow"

    actions = [
      "bedrock:InvokeModel",
      "bedrock:InvokeModelWithResponseStream",
    ]

    resources = ["arn:aws:bedrock:*:*:*"]
  }
}

resource "aws_iam_policy" "bedrock_access_policy" {
  name        = "bedrock_access_policy"
  path        = "/"
  description = "IAM policy for access to bedrock models"
  policy      = data.aws_iam_policy_document.bedrock_access.json
}

data "aws_iam_policy_document" "s3_access" {
  statement {
    effect = "Allow"

    actions = [
      # "s3:*",
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::*"
      # aws_s3_bucket.cds_files.arn,
      # aws_s3_bucket.datasets.arn,
    ]
  }
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3_access_policy"
  path        = "/"
  description = "IAM policy for uploading and downloading s3 objects"
  policy      = data.aws_iam_policy_document.s3_access.json
}

data "aws_iam_policy_document" "dynamodb_access" {
  statement {
    effect = "Allow"

    actions = [
      # "s3:*",
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:ConditionCheckItem",
      "dynamodb:DeleteItem",
      "dynamodb:Describe*",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Get*",
      "dynamodb:List*",
      "dynamodb:UpdateItem",
    ]

    resources = [
      aws_dynamodb_table.collega_datasets.arn,
    ]
  }
}

resource "aws_iam_policy" "dynamodb_access_policy" {
  name        = "dynamodb_access_policy"
  path        = "/"
  description = "IAM policy for accessing dynamo tables from function"
  policy      = data.aws_iam_policy_document.dynamodb_access.json
}
