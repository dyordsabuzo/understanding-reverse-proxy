data "archive_file" "lambda" {
  type        = "zip"
  output_path = "lambda-edge.zip"
  source_file = "lambda.js"
}

data "aws_iam_policy_document" "assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "edgelambda.amazonaws.com",
        "lambda.amazonaws.com"
      ]
    }
  }
}
