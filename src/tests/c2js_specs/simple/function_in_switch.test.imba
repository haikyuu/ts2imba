import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
for(var i = 0; i <5; ++i) {
   switch(i) {
     case 1:
       function foo() { return 2; }
       alert("one");
       break;
   }
}
'''

let imba-code = '''
foo = ->
  2

i = 0
while i < 5
  switch i
    when 1
      alert 'one'
  ++i
'''
test 'function_in_switch' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js