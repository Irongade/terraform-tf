terraform {
    backend "s3" {
        bucket = "tf-state-demo-database-001"
        key    = "development/terraform_state"
        region = "eu-west-2"
    }
}
