import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a.b = function (arg) {
  if (arg) cli.a = b;
  return;
};
'''

let imba-code = '''
a.b = (arg) ->
  if arg
    cli.a = b
  return
'''
test 'nesting_if_and_assignment' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js