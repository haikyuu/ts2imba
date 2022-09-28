import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var list = [
  { a: 1, b: 1 },
  { a: 2, b: 2 },
]
'''

let imba-code = '''
list = [
  {
    a: 1
    b: 1
  }
  {
    a: 2
    b: 2
  }
]
'''
test 'arrray_of_objects' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js