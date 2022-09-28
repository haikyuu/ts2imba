import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
while (true) {
  switch (x) {
    case 1:
      continue;
  }
}
'''

let imba-code = '''
loop
  switch x
    when 1
      continue
'''
test 'switch_with_continue' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js