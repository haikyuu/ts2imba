import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
X.prototype = { a: b };
this.prototype = { a: b };
X.prototype.a = { a: b };
this.prototype.b = { a: b };
'''

let imba-code = '''
X:: = a: b
@:: = a: b
X::a = a: b
@::b = a: b
'''
test 'prototype' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js