# var.xxx で variableで定義した変数を使える
variable "project" {
  description = "プロジェクト名"
  type        = string
}

variable "environment" {
  description = "環境"
  type        = string
}

variable "developer" {
  description = "開発者名"
  type        = string
}

# local.xxxでlocalsで定義した変数を使える
locals {
  name_prefix = "${var.project}-${var.environment}-${var.developer}"
}

resource "aws_cognito_user_pool" "this" {
  name = "${local.name_prefix}-user-pool"

  # Emailログイン
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  # パスワードポリシー
  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = false
    require_uppercase                = false
    temporary_password_validity_days = 7
  }

  # アカウントのリカバリー設定
  # パスワードを忘れた場合、メールアドレスでリセット可能
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  tags = {
    Name = "${local.name_prefix}-user-pool"
  }
}

resource "aws_cognito_user_pool_client" "this" {
  name         = "${local.name_prefix}-app-client"
  user_pool_id = aws_cognito_user_pool.this.id

  access_token_validity  = 60 # 単位: 分（デフォルト60）
  id_token_validity      = 60
  refresh_token_validity = 30 # 単位: 日
  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }

  generate_secret                      = false
  allowed_oauth_flows_user_pool_client = false # Googleとかサードパーティ認証するならtrueらしい

  # 明示的に許可する認証フロー
  # Reactのaws-amplify/authライブラリで使うログイン機能に紐付け
  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",      # パスワードログイン
    "ALLOW_REFRESH_TOKEN_AUTH", # トークン更新
    "ALLOW_CUSTOM_AUTH",        # カスタム認証（MFAやステップ認証などで使う）
    "ALLOW_USER_PASSWORD_AUTH"  # username + password の認証（SRP以外で使うとき）
  ]

  # ログインに使うIDプロバイダー指定
  supported_identity_providers = ["COGNITO"]

  # 存在しないユーザーへのログイン試行時のレスポンスを統一
  # セキュリティ対策として、存在するかどうかを外部から判別されないようにする
  prevent_user_existence_errors = "ENABLED"
}

resource "aws_cognito_user_group" "admin" {
  name         = "admin"
  user_pool_id = aws_cognito_user_pool.this.id
  description  = "アプリ管理者用グループ"
}

output "COGNITO_USER_POOL_ID" {
  description = "CognitoユーザープールID。アプリ側で使用"
  value       = aws_cognito_user_pool.this.id
}

output "COGNITO_CLIENT_ID" {
  description = "CognitoユーザープールID。アプリ側で使用"
  value       = aws_cognito_user_pool_client.this.id
}


# S3バケットの作成
resource "aws_s3_bucket" "sample_bucket" {
  bucket        = "sample-bucket-su-2026-10-02"
  force_destroy = true # バケットが空でなくても削除できる

  tags = {
    Name = "sample-bucket-su-2026-10-02"
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