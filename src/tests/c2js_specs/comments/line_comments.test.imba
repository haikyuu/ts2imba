import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a();
// hello
b();
'''

test 'line_comment 3' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')