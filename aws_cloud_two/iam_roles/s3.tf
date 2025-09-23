#Create AWS S3 Bucket

resource "aws_s3_bucket" "main-s3bucket" {
  bucket = "main-bucket-141"

  tags = {
    Name = "main-bucket-141"
  }
}


