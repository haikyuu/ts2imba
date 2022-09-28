import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function App(){
	return (
		<div className="bg-gray-200">
			<div>
				<img src="" />
			</div>
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
				<div>
					<img src="">
				<span>
					"Test"

'''
test 'self closing' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
