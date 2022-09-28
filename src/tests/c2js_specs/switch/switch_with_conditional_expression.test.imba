import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
switch (a?b:c) {
  case d:
    e();
    break;
}
'''

let imba-code = '''
switch (if a then b else c)
  when d
    e()
'''
test 'switch_with_conditional_expression' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js