# cloudflare-worker-github-oauth-login

> A Cloudflare Worker + GitHub Pages Login Example

The [github-oauth-login.js](github-oauth-login.js) file is a [Cloudflare Worker](https://workers.cloudflare.com/) which is continuously deployed using GitHub Actions (see [.github/workflows/deploy.yml](.github/workflows/deploy.yml)).

The worker does 3 things

1. When you open the worker URL, it will redirect to the OAuth App's login URL on github.com ([example](https://github-oauth-login.gr2m.workers.dev)).
2. It accepts a `POST` request with the OAuth `code` retrieved from the OAuth callback redirect and returns an OAuth access token in return
3. It enables CORS.

The [index.html](index.html) file is a demo of a "Login with GitHub" app, you can see the demo at [gr2m.github.io/cloudflare-worker-github-oauth-login/index.html](https://gr2m.github.io/cloudflare-worker-github-oauth-login/index.html). Look at its source code. If something is unclear, please feel free to [open an issue](https://github.com/gr2m/cloudflare-worker-github-oauth-login/issues) or [ping me on twitter](https://twitter.com/gr2m).

## Step-by-step instructions to create your own

Note that you require access to the new GitHub Actions for the automated deployment to work.

1. [Create a GitHub App](https://developer.github.com/apps/building-github-apps/creating-a-github-app/) or [GitHub OAuth App](https://developer.github.com/apps/building-oauth-apps/creating-an-oauth-app/)
1. Fork this repository
1. [Create a Cloudflare account](https://dash.cloudflare.com/) (it's free!) if you don't have one yet.
1. Install the `wrangler` CLI and login with your account

   ```
   npm install --global wrangler
   wrangler login
   ```

1. Edit the `wrangler.toml` file, change the value for `account_id` to your own ([select your account](https://dash.cloudflare.com/), then find your Account ID at the bottom of the side bar)
1. Add the following secrets to your Cloudflare worker:

   - `CLIENT_ID`, `CLIENT_SECRET`: In your GitHub (OAuth) App's settings page, find `Client ID` and `Client SECRET`

     ```
     wrangler secret put CLIENT_ID
     wrangler secret put CLIENT_SECRET
     ```

1. Add the following secret in your fork's repository settings:
   - `CF_API_TOKEN`: [Create a new token](https://dash.cloudflare.com/profile/api-tokens), use the "Edit Cloudflare Workers" template
1. Enable GitHub Pages in your repository settings, select `Source` to be the `master branch`.
1. In [index.html](index.html), replace the `gr2m` workers subdomain with your own, in `WORKER_URL` and the login `<a href="...">` tag.

That should be it. The `github-oauth-login.js` file will now be continously deployed to Cloudflare each time there is a commit to master.

## See also

- [Cloudflare Worker GitHub App Example](https://github.com/gr2m/cloudflare-worker-github-app-example/#readme)

## Credits

The OAuth App Avatar and this repository's social preview are using [@cameronmcefee](https://github.com/cameronmcefee)'s [cloud](https://octodex.github.com/cloud/) Octodex graphic :octocat:💖

## License

[ISC](LICENSE)
