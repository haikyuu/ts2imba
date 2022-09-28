import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
// OPTIONS: {"single_quotes": true}
var foo = 'bar';

var obj = {
    key: "value",
    escape: 'rock\'n roll "escaped" strings',
    "array": ["one", 2, 'tree'],
    'mixed': "hello" + foo,
    'empty foo bar': '',
    "js-has-no-string-formatting": "#{foo}" + '#{foo}'

};
'''

let imba-code = '''
foo = 'bar'
obj =
  key: 'value'
  escape: 'rock\'n roll "escaped" strings'
  array: [
    'one'
    2
    'tree'
  ]
  mixed: 'hello' + foo
  'empty foo bar': ''
  'js-has-no-string-formatting': '#{foo}' + '#{foo}'
'''
test 'single_quotes' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js