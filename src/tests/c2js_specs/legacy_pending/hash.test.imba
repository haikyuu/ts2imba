import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
x = {
  a: 2,
  b: 3,
  c:
    { one: 1 }
}

console.log({ two:2, three:3 });
'''

let imba-code = '''
x =
  a: 2
  b: 3
  c:
    one: 1

console.log
  two: 2
  three: 3
'''
test 'hash' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js