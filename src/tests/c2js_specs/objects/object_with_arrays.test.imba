import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a = {
  empty: [],
  one: [ 1 ],
  many: [ 1, 2, 3 ]
};
'''

let imba-code = '''
a =
  empty: []
  one: [ 1 ]
  many: [
    1
    2
    3
  ]
'''
test 'object_with_arrays' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js