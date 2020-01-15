terraform {
    backend "s3" {
        bucket         = "remotestate-test-jchitalia"
        encrypt        = true
        key            = "networking/terraform.tfstate"
        profile        = "validityhq"
        region         = "us-east-1"
    }
}
