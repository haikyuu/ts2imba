import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
-1;
+1;
+1 - 1;
+1 -1;
~2 - 2;
~2+-1;
var a =~ 2;
'''

let imba-code = '''
-1
+1
+1 - 1
+1 - 1
~2 - 2
~2 + -1
a = ~2
'''
test 'unary' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js