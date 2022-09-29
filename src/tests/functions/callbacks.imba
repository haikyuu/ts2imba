import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
useEffect(() => {
	ref.current = value
}, [value])
'''

test 'callbacks as first params are handled well' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot!
	const out = imbac.compile(result.code, sourceId: 'sth')

let tsx-code1 = '''
useEffect([value], () => {
	ref.current = value
})
'''

test.only 'callbacks as last params are handled well' do
	const result = await build tsx-code1
	expect(result.code).toMatchSnapshot!
	const out = imbac.compile(result.code, sourceId: 'sth')

