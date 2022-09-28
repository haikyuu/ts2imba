import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
_.propertyOf = function(obj) {
  return obj === null ? (x && function(){}) : function(key) {
    return obj[key];
  };
};
'''

let imba-code = '''
_.propertyOf = (obj) ->
  if obj == null then x and (->
  ) else ((key) ->
    obj[key]
  )
'''
test 'functions_in_ternaries' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js