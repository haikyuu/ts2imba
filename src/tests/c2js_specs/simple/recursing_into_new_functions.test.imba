import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var a = x ? y : function () {
  return a === "b";
};
'''

let imba-code = '''
a = if x then y else (->
  a == 'b'
)
'''
test 'recursing_into_new_functions' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js