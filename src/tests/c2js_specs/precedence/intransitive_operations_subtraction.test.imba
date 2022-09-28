import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a-b-c;

(a-b)-c;
(a+b)-c;
(a-b)+c;
(a+b)+c;

a-(b-c);
a-(b+c);
a+(b-c);
a+(b+c);
'''

let imba-code = '''
a - b - c
a - b - c
a + b - c
a - b + c
a + b + c
a - (b - c)
a - (b + c)
a + b - c
a + b + c
'''
test 'intransitive_operations_subtraction' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js