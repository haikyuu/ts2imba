import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function areQuotesRedundant(rawKey, tokens, skipNumberLiterals) {
	return tokens.length === 1 && tokens[0].start === 0 && tokens[0].end === rawKey.length &&
		(["Identifier", "Keyword", "Null", "Boolean"].includes(tokens[0].type) ||
		(tokens[0].type === "Numeric" && !skipNumberLiterals && String(+tokens[0].value) === tokens[0].value));
}
'''

let imba-code = '''
def areQuotesRedundant(rawKey, tokens, skipNumberLiterals) 
	tokens.length === 1 and tokens[0].start === 0 and tokens[0].end === rawKey.length and [
		"Identifier"
		"Keyword"
		"Null"
		"Boolean"
	].includes(tokens[0].type) or tokens[0].type === "Numeric" and !skipNumberLiterals and String(+tokens[0].value) === tokens[0].value

'''
test 'are quotes redundunt' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js