import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (a) {
  x();
} else if (b) {
  y();
} else {
  z();
}
'''

let imba-code = '''
if a
  x()
else if b
  y()
else
  z()
'''
test 'else_if' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js