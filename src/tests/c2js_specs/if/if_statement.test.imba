import {test, expect} from "vitest"
import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (a) b()
'''

let imba-code = '''
if a
  b()
'''
test 'if_statement' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js