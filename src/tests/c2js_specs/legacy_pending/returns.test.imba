import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function x() {
    if (foo) {
        return 1;
        return true;
    } else {
        return 2;
        return false;
    }
}

function y() {
  return 100;
  return 200;
}

function z() {
  switch (foo) {
    case X:
      return 1;
      return 2;
    case Y:
      return 3;
      return 4;
    default:
      return 5;
      return 6;
  }
}
'''

let imba-code = '''
x = ->
  if foo
    return 1
    true
  else
    return 2
    false
y = ->
  return 100
  200
z = ->
  switch foo
    when X
      return 1
      2
    when Y
      return 3
      4
    else
      return 5
      6
'''
test 'returns' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js