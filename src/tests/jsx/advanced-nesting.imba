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

test 'multiple levels closed at once 31' do
	const result = await build tsx-code2
	expect(result.code).toMatchSnapshot!
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

test 'self closing nesting 12' do
	const result = await build tsx-code3
	expect(result.code).toMatchSnapshot!
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

test 'self closing nesting' do
	const result = await build tsx-code1
	expect(result.code).toMatchSnapshot!
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
test 'advanced nesting 333' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')