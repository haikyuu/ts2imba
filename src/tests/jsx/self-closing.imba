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

test 'self closing 11' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')

let tsx-code2 = '''
function App(){
	return (
		<div className={styles.name}>
		</div>
	)
}
'''

test.only '{} attributes' do
	const result = await build tsx-code2
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
