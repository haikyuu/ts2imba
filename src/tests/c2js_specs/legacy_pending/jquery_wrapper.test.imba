import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
(function($) { return new jQuery.fn.init( selector, context ); })(jQuery);
'''

let imba-code = '''
(($) ->
  new jQuery.fn.init(selector, context)
) jQuery
'''
test 'jquery_wrapper' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js