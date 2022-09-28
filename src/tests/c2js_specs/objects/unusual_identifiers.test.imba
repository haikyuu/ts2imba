import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
object = {
    a: b,
    "a.a": b,
    "a#a": b,
    "a a": b,
    0: b,
    "0.a": b,
    $: b,
    $$: b,
    $a: b,
    "$a b": b
};
'''

let imba-code = '''
object =
  a: b
  'a.a': b
  'a#a': b
  'a a': b
  0: b
  '0.a': b
  $: b
  $$: b
  $a: b
  '$a b': b
'''
test 'unusual_identifiers' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js