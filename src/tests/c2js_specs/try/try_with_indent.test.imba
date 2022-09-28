import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (x) {
  try { a(); }
  catch (e) { b(); }
  finally { c(); }
}
'''

let imba-code = '''
if x
  try
    a()
  catch e
    b()
  finally
    c()
'''
test 'try_with_indent' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js