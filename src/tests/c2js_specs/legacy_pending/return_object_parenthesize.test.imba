import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function parenthesized() {
  return { a: 1, b: 2 };
  a();
}
function not_parenthesized() {
  return { a: 1 };
  a();
}
function parenthesized_b() {
  if (something()) {
    return { a: 1, b: 2 };
  }
}
function parenthesized_c() {
  if (something()) {
    return { a: 1, b: 2 };
  }
  a();
}
'''

let imba-code = '''
parenthesized = ->
  return (
    a: 1
    b: 2
  )
  a()
  return
not_parenthesized = ->
  return a: 1
  a()
  return
parenthesized_b = ->
  if something()
    a: 1
    b: 2
parenthesized_c = ->
  if something()
    return (
      a: 1
      b: 2
    )
  a()
  return
'''
test 'return_object_parenthesize' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js