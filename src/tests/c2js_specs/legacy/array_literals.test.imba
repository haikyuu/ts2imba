import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var arr1 = [];
var arr2 = [1,3,4];
console.log(arr2[1][0] + [4]);
'''

let imba-code = '''
arr1 = []
arr2 = [
  1
  3
  4
]
console.log arr2[1][0] + [ 4 ]
'''
test 'array_literals' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js