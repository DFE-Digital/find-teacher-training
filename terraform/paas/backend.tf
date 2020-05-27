terraform {
  backend azurerm {
    container_name = "paas-tfstate"
    key            = "paas-find.tfstate"
  }
}
