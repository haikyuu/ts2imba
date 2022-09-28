import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var i = 0;
do {
  console.log(i);
  i++;
} while (i < 14);
'''

let imba-code = '''
i = 0
loop
  console.log i
  i++
  unless i < 14
    break
'''
test 'do' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js