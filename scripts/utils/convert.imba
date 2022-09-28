export default def convert(content\string, fileName\string)
	const [comment, tsx-code, imba-code] = content.split('----')
	return if !imba-code
	let o = ""
	o += 'import {build} from "../../../index"\n'
	o += "import * as imbac from 'imba/compiler'\n\n"
	o += """
let tsx-code = '''
{tsx-code.trim!}
'''

let imba-code = '''
{imba-code.trim!}
'''
"""
	o += """\ntest '{fileName}' do
		\tconst result = build tsx-code
		\texpect(result.code).toEqual(imba-code)
		\tconst out = imbac.compile(result.code, sourceId: 'sth')
		\tconsole.log out.js
	"""