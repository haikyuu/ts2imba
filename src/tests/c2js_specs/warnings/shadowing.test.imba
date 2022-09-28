import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function add () { var add = 2; return }
'''

let imba-code = '''
add = ->
  `var add`
  add = 2
  return
'''
test 'shadowing' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js