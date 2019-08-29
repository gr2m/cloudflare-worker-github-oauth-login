# cloudflare-worker-github-oauth-login
> Use a Cloudflare worker for GitHub's OAuth login flow

Just replace the `<Your Apps Client ID/Secret>` placeholder below and use it to create a [Cloudflare worker](https://workers.cloudflare.com/). You get 100,000 requests per day with the free plan which is plenty, even for apps with thousands of active users.

```js
const client_id = '<Your Apps Client ID>'
const client_secret = '<Your Apps Client Secret>'

addEventListener('fetch', event => {
  event.respondWith(handle(event.request))
})

async function handle(request) {
  // handle CORS pre-flight request
  if (request.method === 'OPTIONS') {
    return new Response(null, {
      headers: {
        "Access-Control-Allow-Origin": '*',
        "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type",
      }
    })
  }

  // redirect GET requests to the OAuth login page on github.com
  if (request.method === 'GET') {
    return Response.redirect(`https://github.com/login/oauth/authorize?client_id=${client_id}`, 302)
  }
  
  const { code } = await request.json()

  const response = await fetch('https://github.com/login/oauth/access_token', {
    method: "POST",
    headers: {
      'content-type': "application/json",
      accept: "application/json"
    },
    body: JSON.stringify({ client_id, client_secret, code })
  })
  const result = await response.json()
  const headers = {
    'Access-Control-Allow-Origin': '*'
  }

  if (result.error) {
    return new Response(JSON.stringify(result), { status: 401, headers })
  }

  return new Response(JSON.stringify({ token: result.access_token }), { status: 201, headers })
}
```

## Usage

To login, simply link to your worker's URL, it will redirect the user to the OAuth login page on GitHub. Configure the `Authorization callback URL` to your frontend application. After the redirect, your app has to read out the `?code=...` query parameter and send a `POST` request with `{ code }` body. Example

```js
const WORKER_URL = 'https://my-worker.my-username.workers.dev'
const code = new URL(location.href).searchParams.get('code')
const response = await fetch(WORKER_URL, {
  method: 'POST',
  mode: 'cors',
  headers: {
    'content-type': 'application/json'
  },
  body: JSON.stringify({code})
})
const result = await response.json()

if (result.error) {
  throw new Error(result.error)
}

const { token } = result
// token can no be used to send authenticated requests against https://api.github.com
```

## License

[ISC](LICENSE)
