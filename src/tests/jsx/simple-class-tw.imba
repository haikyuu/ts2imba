import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function App(){
	return (
		<div className="bg-gray-200">
			<span>Test</span>
		</div>
	)
}
'''

let imba-code = '''
tag App
	def render
		<self>
			<div[bgc:gray2]>
				<span>
					"Test"

'''
test 'simple class' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')

let tsx-code2 = '''
function App(){
	return (
		<div className="md:bg-gray-200">
			<span>Test</span>
		</div>
	)
}
'''

let imba-code2 = '''
tag App
	def render
		<self>
			<div[bgc@md:gray2]>
				<span>
					"Test"

'''
test 'simple class with breakpoint' do
	const result = await build tsx-code2
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')

let tsx-code3 = '''
function App(){
	return (
		<div className="md:bg-gray-50">
			<span>Test</span>
		</div>
	)
}
'''

let imba-code3 = '''
tag App
	def render
		<self>
			<div[bgc@md:gray1]>
				<span>
					"Test"

'''
test 'falls back to color1 for color-0.5 in tailwind' do
	const result = await build tsx-code3
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')