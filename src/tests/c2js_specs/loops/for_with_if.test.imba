import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (condition)
  for (a;b;c) if (d) e();
'''

let imba-code = '''
if condition
  a
  while b
    if d
      e()
    c
'''
test 'for_with_if' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js