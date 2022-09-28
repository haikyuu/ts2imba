import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
x = {x:2, b:2}; $.get({x:2, b:2, data: {2: 'post'}, lol: [2,3]}, 2)
'''

let imba-code = '''
x =
  x: 2
  b: 2

$.get
  x: 2
  b: 2
  data:
    2: "post"

  lol: [
    2
    3
  ]
, 2
'''
test 'object_literals' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js