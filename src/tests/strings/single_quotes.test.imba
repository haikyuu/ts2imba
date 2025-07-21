import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code = "'\\n'"

test 'single_quotes' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js
