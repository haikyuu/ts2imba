import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var options;
if ( (options = arguments[ i ]) !== null ) {
  for (var x in y) { z(); }
}
'''

let imba-code = '''
options = undefined
if (options = arguments[i]) != null
  for x of y
    z()
'''
test 'assignment_in_condition' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js