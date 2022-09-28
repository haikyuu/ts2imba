import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code4 = '''
let x = (i, j) => i+j
'''

test 'two params 33' do
	const result = await build tsx-code4
	expect(result.code).toMatchSnapshot!
	const out = imbac.compile(result.code, sourceId: 'sth')


let tsx-code1 = '''
let App = () => {
	let a = 34
	return a
}
'''

test 'arrow functions 1223' do
	const result = await build tsx-code1
	expect(result.code).toMatchSnapshot!
	const out = imbac.compile(result.code, sourceId: 'sth')

let tsx-code = '''
let App = () => {
	return (
		<div>
			<span>Test</span>
		</div>
	)
}
'''

test 'arrow functions component' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')

let tsx-code3 = '''
const b64toBlob = (b64Data, contentType='', sliceSize=512) => {
  const byteCharacters = atob(b64Data);
}
'''

test 'assignment pattern 23' do
	const result = await build tsx-code3
	expect(result.code).toMatchSnapshot!
	const out = imbac.compile(result.code, sourceId: 'sth')
