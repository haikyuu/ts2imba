import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var re = /=/;
console.log("a = b".match(re));
'''

let imba-code = '''
re = RegExp('=')
console.log 'a = b'.match(re)
'''
test 'equal_regex' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js