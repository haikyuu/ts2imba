import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function noReturn() {
  f();
}

function noReturnIf1() {
  if (condition) {
    doSomething();
    return 1;
  }
  else {
    doSomethingElse();
  }
}

function noReturnIf2() {
  if (condition) {
    doSomething();
  }
  else {
    doSomethingElse();
    return 2;
  }
}
'''

let imba-code = '''
noReturn = ->
  f()
  return
noReturnIf1 = ->
  if condition
    doSomething()
    1
  else
    doSomethingElse()
  return
noReturnIf2 = ->
  if condition
    doSomething()
  else
    doSomethingElse()
    2
  return
'''
test 'no_return' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js