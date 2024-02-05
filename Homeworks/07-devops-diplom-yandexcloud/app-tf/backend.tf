terraform {
  backend "remote" {
    organization = "alxcreate"

    workspaces {
      name = "app"
    }
  }
}
