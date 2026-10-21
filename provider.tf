provider "aws" {
  region     = "eu-west-1"
  access_key = "test"
  secret_key = "test"

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

endpoints {
    ec2 = "http://192.168.165.135:4566" 
  }
}