import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
0 instanceof a;
!(1 instanceof a);
!!(2 instanceof a);
!!!(3 instanceof a);
if(a instanceof b) 4;
if(!(a instanceof b)) 5;
!(6 instanceof a) || b;
(!(7 instanceof a)) + b;
if(!(a instanceof b) || c) 8;
if(!(a instanceof b) + c) 9;
'''

let imba-code = '''
0 instanceof a
(1 not instanceof a)
!!(2 instanceof a)
(3 not instanceof a)
4  if a instanceof b
5  unless a instanceof b
(6 not instanceof a) or b
(7 not instanceof a) + b
8  if (a not instanceof b) or c
9  if (a not instanceof b) + c
'''
test 'instanceof' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js