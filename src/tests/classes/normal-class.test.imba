import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
class Comp{
	render(){
		return <img />
	}	
}
'''

let imba-code = '''
class Comp
	def render
		<img>

'''
test 'spaces_4' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')