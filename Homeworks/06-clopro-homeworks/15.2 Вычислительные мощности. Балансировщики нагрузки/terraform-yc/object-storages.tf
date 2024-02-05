resource "yandex_storage_bucket" "netology-bucket-wfghad" {
  access_key = var.access_key
  secret_key = var.secret_key
  bucket     = "netology-bucket-wfghad"
  max_size   = 1048576
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
