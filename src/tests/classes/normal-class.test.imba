import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
class Comp{
	render(){
		return <img />
	}	
}
'''

test 'normal class with jsx' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')