import fs from "fs"
import path, {dirname, basename} from "path"
import {pathToFileURL} from "url"
import express from "express"
import {build} from "./src"
import cors from 'cors'
import Vite from 'vite'

const corsOptions = {
	origin: 'https://ts2imba.com',
	optionsSuccessStatus: 200
}
let port = +process.env.PORT or 3000
const args = process.argv.slice(2)
const portArgPos = args.indexOf("--port") + 1
if portArgPos > 0
	port = parseInt(args[portArgPos], 10)

def createServer(root = process.cwd(), isProd = process.env.NODE_ENV === "production")
	let vite
	const app = express()
	app.use express.json()
	app.use cors(corsOptions)

	app.post("/api/imba") do(req, res)
		const tsx-code = req.body..code
		return res.send("") unless tsx-code
		try 
			const result = await build tsx-code 
			res.send code: result.code.replace(/\n$/, "")
		catch error
			console.error error
			res.send code: error.message
	if !isProd
		vite = await Vite.createServer
			root: root
			appType: "custom"
			configFile: "vite.config.js"
			server:
				middlewareMode: true
				port: port + 33
				strictPort: true
				hmr:
					port: port + 25000
		app.use vite.middlewares
		app.use "*", do(req, res)
			const url = req.originalUrl
			try
				let html = String <html lang="en">
					<head>
						<meta charset="UTF-8">
						<meta name="viewport" content="width=device-width, initial-scale=1.0">
						<title> "Imba App"
						<script type="module" src="/@vite/client">
						<script type="module" src="/app/main.js">
				res.status(200).set("Content-Type": "text/html").end html
			catch e
				vite and vite.ssrFixStacktrace(e)
				console.log e.stack
				res.status(500).end e.stack
	const server = imba.serve app.listen port, do console.log "http://localhost:{port}"
	const exitProcess = do
		process.off "SIGTERM", exitProcess
		process.off "SIGINT", exitProcess
		process.stdin.off "end", exitProcess
		try await server.close do console.log "server closed" finally process.exit 0

	process.once "SIGTERM", exitProcess
	process.once "SIGINT", exitProcess
	process.stdin.on "end", exitProcess

createServer!