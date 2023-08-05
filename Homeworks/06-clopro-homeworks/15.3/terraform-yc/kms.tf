resource "yandex_kms_symmetric_key" "object-storage-key" {
  name              = "object-storage-key"
  description       = "Key for object storage encryption"
  default_algorithm = "AES_128" # Алгоритм шифрования. Возможные значения: AES-128, AES-192 или AES-256.
  rotation_period   = "8760h"   # 1 год. Период ротации (частота смены версии ключа по умолчанию).
  lifecycle {
    prevent_destroy = true # Защита ключа от удаления (например, командой terraform destroy)
  }
}
