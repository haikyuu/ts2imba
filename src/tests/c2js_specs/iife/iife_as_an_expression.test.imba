import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
$((function() { return true; })())
'''

let imba-code = '''
$ do ->
  true
'''
test 'iife_as_an_expression' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js