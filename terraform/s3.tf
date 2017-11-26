variable "bucket_name" {
  default = "webapp.daisaru11"
}

resource "aws_s3_bucket" "webapp" {
  bucket = "${var.bucket_name}"
  acl    = "private"
  policy = "${template_file.s3_policy.rendered}"

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket" "webapp_cf_logs" {
  bucket = "webapp.log.daisaru11"
  acl    = "private"
}

resource "template_file" "s3_policy" {
  template = "${file("${path.module}/s3_policy.json.tpl")}"

  vars {
    bucket_name            = "${var.bucket_name}"
    origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.id}"
  }
}
