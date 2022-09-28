import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code2 = '''
function App(){
	return (
		<div>
			<section>
				<div>
					<div>
						<h2>Title</h2>
					</div>
				</div>
			</section>
			<footer>F</footer>
		</div>
	)
}
'''

let imba-code2 = '''
tag App
	def render
		<self>
			<div>
				<section>
					<div>
						<div>
							<h2>
								"Title"
				<footer>
					"F"

'''
test 'multiple levels closed at once' do
	const result = await build tsx-code2
	expect(result.code).toEqual(imba-code2)
	const out = imbac.compile(result.code, sourceId: 'sth')

let tsx-code3 = '''
function App(){
	return (
		<div>
			<div>
				<h3>Title</h3>
			</div>
			<footer>F</footer>
		</div>
	)
}
'''

let imba-code3 = '''
tag App
	def render
		<self>
			<div>
				<div>
					<h3>
						"Title"
				<footer>
					"F"

'''
test 'self closing nesting' do
	const result = await build tsx-code3
	expect(result.code).toEqual(imba-code3)
	const out = imbac.compile(result.code, sourceId: 'sth')



let tsx-code1 = '''
function App(){
	return (
		<div>
			<a href="" />
			<span>Test 2</span>
		</div>
	)
}
'''

let imba-code1 = '''
tag App
	def render
		<self>
			<div>
				<a href="">
				<span>
					"Test 2"

'''
test 'self closing nesting' do
	const result = await build tsx-code1
	expect(result.code).toEqual(imba-code1)
	const out = imbac.compile(result.code, sourceId: 'sth')


let tsx-code = '''
function App(){
	return (
		<div>
			<span>Test</span>
			<div>
				<h2>Title</h2>
				<div>
					<span>
						<a href="" />
						<span>Test 2</span>
						Text
					</span>
				</div>
			</div>
			<footer>F</footer>
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
				<div>
					<h2>
						"Title"
					<div>
						<span>
							<a href="">
							<span>
								"Test 2"
							"Text"
				<footer>
					"F"

'''
test 'advanced nesting' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')