resource "yandex_storage_bucket" "netology-bucket-wfghad" {
  access_key = var.access_key
  secret_key = var.secret_key
  bucket     = "netology-bucket-wfghad"
  max_size   = 1048576
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.object-storage-key.id # Идентификатор мастер ключа KMS, используемый для шифрования
        sse_algorithm     = "aws:kms"                                      # Используемый алгоритм шифрования на стороне сервера. Поддерживается только значение aws:kms
      }
    }
  }
}

resource "yandex_storage_object" "iceberg" {
  depends_on = [yandex_storage_bucket.netology-bucket-wfghad]
  access_key = var.access_key
  secret_key = var.secret_key
  bucket     = "netology-bucket-wfghad"
  key        = "Iceberg.jpg"
  source     = "content/Iceberg.jpg"
  acl        = "public-read"
}
