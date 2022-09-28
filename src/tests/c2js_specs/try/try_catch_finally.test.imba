import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
try {
  a();
} catch (e) {
  b();
} finally {
  c();
}
'''

let imba-code = '''
try
  a()
catch e
  b()
finally
  c()
'''
test 'try_catch_finally' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js