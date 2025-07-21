import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var a = [ 1, 2, 3, 4 ]
'''

let imba-code = '''
let a = [
	1
	2
	3
	4
]

'''
test 'multiple_items' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	expect(out.js).toBeDefined()
