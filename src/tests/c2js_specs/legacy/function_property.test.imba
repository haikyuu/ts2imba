import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
(function (){}.apa);
var f = function(){}.bind(this);
'''

let imba-code = '''
(->
).apa
f = (->
).bind(this)
'''
test 'function_property' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js