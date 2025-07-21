import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code2 = '''
function App(){
	return (
		<button onClick={()=>console.log("2")}>
		</button>
	)
}
'''

test 'multiple levels closed at once 31' do
	const result = await build tsx-code2
	expect(result.code).toMatchSnapshot!
	const out = imbac.compile(result.code, sourceId: 'sth')
	expect(out.js).toBeDefined()
