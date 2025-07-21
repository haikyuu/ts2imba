import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var a = []
'''
test 'empty_array' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	expect(out.js).toBeDefined()
