import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
0.094;
91;
9;
0;
-1;
-20.89889;
-424;
482934.00000001;
'''

let imba-code = '''
0.094
91
9
0
-1
-20.89889
-424
482934.00000001
'''
test 'floating_point_numbers' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js