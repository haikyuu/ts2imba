import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if(e){
	let a =2
}else{
	let b = 2
}
'''

test 'if else basic 124' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')