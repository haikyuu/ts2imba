import {build} from "../../index.imba"
import * as imbac from 'imba/compiler'

let tsx-code = '''
export const headers = {
  xInertia: 'x-inertia',
  xInertiaVersion: 'x-inertia-version',
  xInertiaLocation: 'x-inertia-location',
  xInertiaPartialData: 'x-inertia-partial-data',
  xInertiaPartialComponent: 'x-inertia-partial-component',
  xInertiaCurrentComponent: 'x-inertia-current-component',
};
'''

test 'inertia example 32' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')