import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
for(i = 0; i <5; ++i) {
   if(i == 2) {
       continue;
   }
   alert(i);
}

for(i = 0; i <5; ++i) {
   switch(i) {
   case 1:
       alert("one");
       break;
   case 2:
   case 3:
       continue
       break;
   default:
       alert(i);
   }
}
'''

let imba-code = '''
i = 0
while i < 5
  continue  if i is 2
  alert i
  ++i
i = 0
while i < 5
  switch i
    when 1
      alert "one"
    when 2, 3
      continue
    else
      alert i
  ++i
'''
test 'for_continue' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js