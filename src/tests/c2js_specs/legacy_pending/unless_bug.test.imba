import {test, expect} from "vitest"
import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (true)
 foo();
else {
 bar();
}
if (a)
  A();
if (!b)
  notB();
else if (c)
  C();
else if (!d)
  notD();
else {
  foobar();
}
'''

let imba-code = '''
if true
  foo()
else
  bar()
A()  if a
unless b
  notB()
else if c
  C()
else unless d
  notD()
else
  foobar()
'''
test 'unless_bug' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js