import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var a = this;
'''

let imba-code = '''
a = this
'''
test 'standalone_this' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js