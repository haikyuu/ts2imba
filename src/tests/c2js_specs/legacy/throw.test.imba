import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
try {
throw 2;} catch(x) { alert (x); }
'''

let imba-code = '''
try
  throw 2
catch x
  alert x
'''
test 'throw' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js