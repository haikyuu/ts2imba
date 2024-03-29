import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function a() {
  console.log("Hello");
  return { a: 1, b: 2 };
}
function b() {
  console.log("Hello");
  return { a: 1 };
}
function c() {
  return { a: 1, b: 2 };
}
function d() {
  ({ c: 3 });
  return { a: 1, b: 2 };
}
'''

let imba-code = '''
a = ->
  console.log "Hello"
  a: 1
  b: 2
b = ->
  console.log "Hello"
  a: 1
c = ->
  a: 1
  b: 2
d = ->
  c: 3
  (
    a: 1
    b: 2
  )
'''
test 'return_object' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js