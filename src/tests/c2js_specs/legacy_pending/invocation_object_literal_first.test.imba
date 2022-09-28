import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
test({url: url}, options || {});
'''

let imba-code = '''
test
  url: url
, options or {}
'''
test 'invocation_object_literal_first' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js