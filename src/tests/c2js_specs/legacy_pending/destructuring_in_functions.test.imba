import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
(function([a]){return true;});
(function([a,b]){return true;});
(function([a,b],c){return true;});
(function(x,[a,b]){return true;});
(function(x,[a,b],c){return true;});
'''

let imba-code = '''
([a]) ->
  true

([
  a
  b
]) ->
  true

([
  a
  b
], c) ->
  true

(x, [
  a
  b
]) ->
  true

(x, [
  a
  b
], c) ->
  true
'''
test 'destructuring_in_functions' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js