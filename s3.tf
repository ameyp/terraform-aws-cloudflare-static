resource "aws_s3_bucket" "hugo" {
  bucket = "${var.project_name}-intermediate"
  acl    = "private"
}

// For the www domain, redirects to the root domain.
resource "aws_s3_bucket" "hugo_final" {
  bucket = "${var.www_domain_name}"
  acl    = "public-read"
  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::${var.www_domain_name}/*"
      ]
    }
  ]
}
EOF

  website {
    redirect_all_requests_to = "https://${var.root_domain_name}"
  }

}

// For the root domain
resource "aws_s3_bucket" "hugo_root" {
  bucket = "${var.root_domain_name}"
  acl    = "public-read"
  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect":"Allow",
      "Principal": "*",
      "Action":[
        "s3:GetObject"
      ],
      "Resource":[
        "arn:aws:s3:::${var.root_domain_name}/*"
      ]
    }
  ]
}
POLICY

  website {
    // Here we tell S3 what to use when a request comes in to the root
    // ex. https://www.runatlantis.io
    index_document = "index.html"
    // The page to serve up if a request results in an error or a non-existing
    // page.
    error_document = "404.html"
  }
}
