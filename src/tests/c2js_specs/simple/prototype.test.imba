import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a.prototype.b = 1
a.prototype = {}
'''

let imba-code = '''
a::b = 1
a.prototype = {}
'''
test 'prototype' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js