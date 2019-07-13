ui = true
disable_mlock = true

storage "mysql" {
  address = "10.5.0.6"
  database = "vaultdb"
  table    = "vault-data"
  username = "vaultadm"
  password = "vaultp@ss"
  lock_table = "vault_lock"
}

listener "tcp" {
  address = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"
  tls_disable = true
}
