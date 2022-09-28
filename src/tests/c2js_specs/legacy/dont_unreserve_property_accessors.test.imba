import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
io.on('data', function() { console.log('Received'); });
this.on('data', function() { console.log('Received'); });
'''

let imba-code = '''
io.on 'data', ->
  console.log 'Received'
  return
@on 'data', ->
  console.log 'Received'
  return
'''
test 'dont_unreserve_property_accessors' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js