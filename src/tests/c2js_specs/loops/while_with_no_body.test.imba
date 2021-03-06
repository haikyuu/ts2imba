import {test, expect} from "vitest"
import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (true) {
  while (a) {
  }
}
'''

let imba-code = '''
if true
  while a
    continue
'''
test 'while_with_no_body' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js