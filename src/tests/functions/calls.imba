import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
Buffer.from(output, "binary")
'''

test 'simple calls work as expected' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot!
	const out = imbac.compile(result.code, sourceId: 'sth')
	expect(out.js).toBeDefined()

let tsx-code2 = '''
res.writeHead(409, { [headers.xInertiaLocation]: req.url }).end()
'''

test 'simple calls work as expected 2' do
	const result = await build tsx-code2
	expect(result.code).toMatchSnapshot!
	const out = imbac.compile(result.code, sourceId: 'sth')
	expect(out.js).toBeDefined()
let tsx-code3 = '''
res.status(_statusCode)
.set({
	...req.headers,
	..._headers,
	'Content-Type': 'text/html',
})
.send(html(_page, _viewData));'''

test 'simple calls work as expected 3' do
	const result = await build tsx-code3
	expect(result.code).toMatchSnapshot!
	const out = imbac.compile(result.code, sourceId: 'sth')
	expect(out.js).toBeDefined()
