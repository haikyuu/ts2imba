import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
switch (x) {
 case 1:
 case 2: 
 case 3: foo()
 case 4: bar()
}

switch (x) {
 case 4: case 5: case 6: baz()
}
'''

let imba-code = '''
switch x
  when 1, 2, 3
    foo()
  when 4
    bar()
switch x
  when 4, 5, 6
    baz()
'''
test 'switch_gt_two' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js