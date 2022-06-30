import express from 'express'
import index from './app/index.html'
import {build} from "./src/index"
import path from 'path'

let app = express!
# const json-body = express.json(limit: '2mb')
import fs from 'fs'


app.use(express.json());

app.post("/imba") do(req, res)
	console.log req.body
	const tsx-code = req.body..code
	return res.send("") unless tsx-code
	try 
		const result = await build tsx-code 
		res.send code: result.code
	catch error
		res.send code: error.message
# catch-all route that returns our index.html
app.get(/.*/) do(req,res)
	# only render the html for requests that prefer an html response
	unless req.accepts(['image/*', 'html']) == 'html'
		return res.sendStatus(404)

	res.send index.body


def start
	let server = app
	const port = process.env.PORT or 3000
	if process.env.NODE_ENV == "production"
		let key = fs.readFileSync(path.join __dirname, "certs/selfsigned.key")
		let cert = fs.readFileSync(path.join __dirname, "certs/selfsigned.crt")
		let options = 
			key: key
			cert: cert
		const https = require('https')
		server = https.createServer(options, app)

	imba.serve server.listen(port) do
		console.log "server listening on PORT {port}"

start!