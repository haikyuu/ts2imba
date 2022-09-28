import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
(function($) {
  go();
  return;
})(jQuery);
'''

let imba-code = '''
(($) ->
  go()
  return
) jQuery
'''
test 'iife_with_different_argument_names' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js