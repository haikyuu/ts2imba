import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
App = {
  start: function () { go(); return; },
  stop: function () { halt(); return; }
}
'''

let imba-code = '''
App =
  start: ->
    go()
    return
  stop: ->
    halt()
    return
'''
test 'singleton_with_methods' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js