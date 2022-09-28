import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
for (var x in y) { alert(1) }
for (var key in obj) {}
for (key in obj)
    single_liner()
'''

let imba-code = '''
for x of y
  alert 1
for key of obj
  continue
for key of obj
  single_liner()
'''
test 'for_in' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js