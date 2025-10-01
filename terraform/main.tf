# S3バケットの作成
resource "aws_s3_bucket" "sample_bucket" {
  bucket = "my-unique-bucket-name-20250626"
  force_destroy = true # バケットが空でなくても削除できる

  tags = {
    Name = "sample-bucket"
  }
}

# S3バケットの公開アクセスをブロックする
resource "aws_s3_bucket_public_access_block" "sample_block" {
  bucket = aws_s3_bucket.sample_bucket.id

  block_public_acls       = true # 公開ACL付与できない
  block_public_policy     = true # 公開ACL無視
  ignore_public_acls      = true # 公開を拒否
  restrict_public_buckets = true # 公開ポリシー経由でアクセス不可
}