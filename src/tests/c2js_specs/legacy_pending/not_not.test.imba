import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
!x;
!!x;
!!!x;
!!!!x;
!!!!!x;
'''

let imba-code = '''
not x
!!x
not x
!!x
not x
'''
test 'not_not' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js