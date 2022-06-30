import {Application, Router} from "https://deno.land/x/oak/mod.ts"
import {serve} from './deno_serve/serve.js'

const router = new Router

router.get "/", do(ctx)
	ctx.response.body = `<!DOCTYPE html>
		<html>
			<head><title>Hello oak!</title><head>
			<body>
			<h1>Hello oak!</h1>
			</body>
		</html>
	`

const app = new Application
app.use router.routes!
app.use router.allowedMethods!

serve app.listen port: 8080