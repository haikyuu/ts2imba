import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
get().then(function () {
  return a();
}).then(function () {
  return b();
});
'''

let imba-code = '''
get().then(->
  a()
).then ->
  b()
'''
test 'chaining' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js