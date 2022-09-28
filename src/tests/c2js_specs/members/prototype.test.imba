import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a.prototype.b = {};
a.prototype;
'''

let imba-code = '''
a::b = {}
a.prototype
'''
test 'prototype' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js