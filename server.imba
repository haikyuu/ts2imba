import fs from "fs"
import path, {dirname, basename} from "path"
import {pathToFileURL} from "url"
import express from "express"
import {build} from "./src"
import cors from 'cors'

const corsOptions = {
	origin: 'https://ts2imba.com',
	optionsSuccessStatus: 200
}
let port = 3000
const args = process.argv.slice(2)
const portArgPos = args.indexOf("--port") + 1
if portArgPos > 0
	port = parseInt(args[portArgPos], 10)

def createServer(root = process.cwd(), isProd = process.env.NODE_ENV === "production")
	const app = express()
	app.use express.json()
	app.use cors(corsOptions)
	app.post("/api/imba") do(req, res)
		console.log "helloo"
		const tsx-code = req.body..code
		return res.send("") unless tsx-code
		try 
			const result = await build tsx-code 
			res.send code: result.code.replace(/\n$/, "")
		catch error
			console.error error
			res.send code: error.message
	app

let app = createServer()
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

