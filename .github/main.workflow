workflow "Deploy Cloudflare Worker" {
  on = "push"
  resolves = ["deploy"]
}

action "deploy" {
  uses = "cloudflare/serverless-action@master"
  env = {
    CLOUDFLARE_SCRIPT_NAME = "github-oauth-login"
  }
  secrets = ["CLOUDFLARE_AUTH_EMAIL", "CLOUDFLARE_ZONE_ID", "CLOUDFLARE_ACCOUNT_ID", "CLOUDFLARE_AUTH_KEY"]
}
