# cloudflare-worker-github-oauth-login

> Use a Cloudflare worker for GitHub's OAuth login flow

Example [Cloudflare Worker](https://workers.cloudflare.com/) that can be used for "Login with GitHub" functionality (OAuth login), e.g. for static web applications.

See [github-oauth-login.js](github-oauth-login.js) for the source code.

The worker is continously deployed using GitHub Actions. When you fork this repository to deploy your own worker, make sure to configure the environment variables accordinly. You find `CLOUDFLARE_ACCOUNT_ID` and `CLOUDFLARE_ZONE_ID` on [httpsdash.cloudflare.com](https://dash.cloudflare.com/), select your account, then select your website, the IDs are listed in the sidebar's API section.

## Usage

To login, simply link to your worker's URL, it will redirect the user to the OAuth login page on GitHub. Configure the `Authorization callback URL` to your frontend application's URL. After the redirect, your application has to read out the `?code=...` query parameter and send a `POST` request with `{ code }` body. Example

```js
const WORKER_URL = "https://my-worker.my-username.workers.dev";
const code = new URL(location.href).searchParams.get("code");
const response = await fetch(WORKER_URL, {
  method: "POST",
  mode: "cors",
  headers: {
    "content-type": "application/json"
  },
  body: JSON.stringify({ code })
});
const result = await response.json();

if (result.error) {
  throw new Error(result.error);
}

const { token } = result;
// token can now be used to send authenticated requests against https://api.github.com
const getUserResponse = fetch("https://api.github.com/user", {
  headers: {
    accept: "application/vnd.github.v3+json",
    authorization: `token ${token}`
  }
});
const user = getUserResponse.json();
```

## License

[ISC](LICENSE)
