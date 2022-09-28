import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function App(){
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
test 'spaces_4' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')