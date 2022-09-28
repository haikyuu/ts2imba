import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
(function() { console.log("Listening to %d", port); })();
'''

let imba-code = '''
(->
  console.log "Listening to %d", port
  return
)()
'''
test 'percent_d' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js