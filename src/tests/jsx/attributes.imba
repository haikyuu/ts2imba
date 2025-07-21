import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function App(){
	return (
		<input onChange={()=> {
			console.log('changed');
			let a = new Date()
			return a
		}} />
	)
}
'''

test 'jsx attributes 1' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	expect(out.js).toBeDefined()


let tsx-code2 = '''
function App(){
	return (
		<input onChange={()=> {
			console.log('changed');
		}} />
	)
}
'''

test 'jsx attributes 2' do
	const result = await build tsx-code2
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	expect(out.js).toBeDefined()
