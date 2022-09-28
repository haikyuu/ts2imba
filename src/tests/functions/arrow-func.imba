import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code4 = '''
let x = (i, j) => i+j
'''

let imba-code4 = '''
let x = do(i, j) i + j

'''
test 'two params' do
	const result = await build tsx-code4
	expect(result.code).toEqual(imba-code4)
	const out = imbac.compile(result.code, sourceId: 'sth')


let tsx-code1 = '''
let App = () => {
	let a = 34
	return a
}
'''

let imba-code1 = '''
let App = do
	let a = 34
	a

'''
test 'arrow functions ' do
	const result = await build tsx-code1
	expect(result.code).toEqual(imba-code1)
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

let imba-code = '''
tag App
	def render
		<self>
			<div>
				<span>
					"Test"

'''
test 'arrow functions component' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')

let tsx-code3 = '''
const b64toBlob = (b64Data, contentType='', sliceSize=512) => {
  const byteCharacters = atob(b64Data);
}
'''

let imba-code3 = '''
const b64toBlob = do(b64Data, contentType = "", sliceSize = 512)
	const byteCharacters = atob(b64Data)
	return

'''
test 'assignment pattern' do
	const result = await build tsx-code3
	console.log result.code
	expect(result.code).toEqual(imba-code3)
	const out = imbac.compile(result.code, sourceId: 'sth')
