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

let imba-code = '''
export const headers = 
	xInertia: "x-inertia"
	xInertiaVersion: "x-inertia-version"
	xInertiaLocation: "x-inertia-location"
	xInertiaPartialData: "x-inertia-partial-data"
	xInertiaPartialComponent: "x-inertia-partial-component"
	xInertiaCurrentComponent: "x-inertia-current-component"

'''
test 'inertia example' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')