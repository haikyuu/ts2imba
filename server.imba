import fs from "fs"
import path, {dirname, basename} from "path"
import {pathToFileURL} from "url"
import express from "express"
import compression from "compression"
import serveStatic from "serve-static"
import App from './app/main.imba'
import * as Vite from "vite"
import {build} from "./src"

let port = 3000
const args = process.argv.slice(2)
const portArgPos = args.indexOf("--port") + 1
if portArgPos > 0
	port = parseInt(args[portArgPos], 10)

const CLIENT_ENTRY = "app/main.js"
# The server entry is used in the launch.imba file
# not used here
# const SERVER_ENTRY = "app/main.imba"

def createServer(root = process.cwd(), isProd = process.env.NODE_ENV === "production")
	const resolve = do(p) path.resolve(root, p)

	let manifest\Object
	if isProd
		manifest = (await import("./dist/manifest.json")).default
	const app = express()
	app.use(express.json());
	let vite
	if !isProd
		vite = await Vite.createServer
			root: root
			appType: "custom"
			configFile: "vite.config.js"
			server:
				middlewareMode: true
				port: port
				strictPort: true
				hmr:
					port: port + 25000
		app.use vite.middlewares
	else
		const inlineCfg = 
			root: root
			appType: "custom"
			server:
				middlewareMode: true
		# maybe use a different config
		vite = await Vite.createServer()
		app.use compression()
		app.use serveStatic(resolve("dist"), index: false)
	app.post("/imba") do(req, res)
		const tsx-code = req.body..code
		return res.send("") unless tsx-code
		try 
			const result = await build tsx-code 
			res.send code: result.code.replace(/\n$/, "")
		catch error
			console.error error
			res.send code: error.message
	app.use "*", do(req, res)
		const url = req.originalUrl
		try
			let html = String <html lang="en">
				<head>
					<meta charset="UTF-8">
					<meta name="viewport" content="width=device-width, initial-scale=1.0">
					<title> "Imba App"
					if !isProd
						<script type="module" src="/@vite/client">
						<script type="module" src="/{CLIENT_ENTRY}">
					else
						const prod-src = manifest[CLIENT_ENTRY].file
						const css-files = manifest[CLIENT_ENTRY].css
						<script type="module" src=prod-src>
						for css-file in css-files
							<style src=css-file>
			res.status(200).set("Content-Type": "text/html").end html
		catch e
			vite and vite.ssrFixStacktrace(e)
			console.log e.stack
			res.status(500).end e.stack
	return
		app: app
		vite: vite

createServer().then do({app})
	console.log "server created"
	const server = app.listen port, do console.log "http://localhost:{port}"
	const exitProcess = do
		process.off "SIGTERM", exitProcess
		process.off "SIGINT", exitProcess
		process.stdin.off "end", exitProcess
		try await server.close do console.log "server closed" finally process.exit 0

	process.once "SIGTERM", exitProcess
	process.once "SIGINT", exitProcess
	process.stdin.on "end", exitProcess

