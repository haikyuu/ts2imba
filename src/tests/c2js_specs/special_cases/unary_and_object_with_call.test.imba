import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
!{ toString: null }.propertyIsEnumerable('string')
'''

let imba-code = '''
!{ toString: null }.propertyIsEnumerable('string')
'''
test 'unary_and_object_with_call' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js