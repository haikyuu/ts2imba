import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
import * as dns from 'dns'

async function resolveDomain(domain) {
	const records = (await dns.resolveTxt(domain)).flat();
	return records;
}
'''

test 'dns resolve with flat' do
	const result = await build tsx-code
	expect(result.code).toContain('(await dns.resolveTxt(domain)).flat()')
	expect(result.code).not.toContain('await dns.resolveTxt(domain).flat()')
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	expect(out.js).toBeDefined()
