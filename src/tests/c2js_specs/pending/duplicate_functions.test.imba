import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function a() { b(); }
function a() { c(); }
'''

let imba-code = '''
a = ->
  b()
'''
test 'duplicate_functions' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js