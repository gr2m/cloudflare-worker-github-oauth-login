workflow "Deploy Worker" {
  on = "push"
  resolves = ["Deploy Worker"]
}

action "Deploy Worker" {
  uses = "cloudflare/serverless-action@master"
  env = {
    CLOUDFLARE_SCRIPT_NAME = "github-oauth-login"
  }
  secrets = ["CLOUDFLARE_AUTH_EMAIL", "CLOUDFLARE_ZONE_ID", "CLOUDFLARE_ACCOUNT_ID", "CLOUDFLARE_AUTH_KEY"]
}
