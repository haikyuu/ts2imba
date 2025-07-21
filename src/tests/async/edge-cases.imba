import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code1 = '''
async function test1() {
	const records = (await dns.resolveTxt(domain)).flat().filter(x => x);
	return records;
}
'''

let tsx-code2 = '''
async function test2() {
	const result = (await fetch(url)).json();
	return result;
}
'''

let tsx-code3 = '''
async function test3() {
	const data = ((await api.getData())).map(x => x.id);
	return data;
}
'''

let tsx-code4 = '''
async function test4() {
	const nested = (await (await fetch(url)).json()).data;
	return nested;
}
'''

let tsx-code5 = '''
async function test5() {
	const computed = (await api.getData())[0].value;
	return computed;
}
'''

let tsx-code6 = '''
async function test6() {
	const chained = (await promise1).method1().method2().method3();
	return chained;
}
'''

let tsx-code7 = '''
async function test7() {
	const optional = (await maybePromise)?.optionalMethod?.();
	return optional;
}
'''

test 'async with chained methods' do
	const result1 = await build tsx-code1
	expect(result1.code).toContain('(await dns.resolveTxt(domain)).flat().filter')
	expect(result1.code).toMatchSnapshot()
	const out1 = imbac.compile(result1.code, sourceId: 'test1')

test 'async with json method' do
	const result2 = await build tsx-code2
	expect(result2.code).toContain('(await fetch(url)).json()')
	expect(result2.code).toMatchSnapshot()
	const out2 = imbac.compile(result2.code, sourceId: 'test2')

test 'async with double parentheses' do
	const result3 = await build tsx-code3
	expect(result3.code).toContain('(await api.getData()).map')
	expect(result3.code).toMatchSnapshot()
	const out3 = imbac.compile(result3.code, sourceId: 'test3')

test 'nested async expressions' do
	const result4 = await build tsx-code4
	expect(result4.code).toContain('(await (await fetch(url)).json()).data')
	expect(result4.code).toMatchSnapshot()
	const out4 = imbac.compile(result4.code, sourceId: 'test4')

test 'async with computed property access' do
	const result5 = await build tsx-code5
	expect(result5.code).toContain('(await api.getData())[0].value')
	expect(result5.code).toMatchSnapshot()
	const out5 = imbac.compile(result5.code, sourceId: 'test5')

test 'async with multiple chained methods' do
	const result6 = await build tsx-code6
	expect(result6.code).toContain('(await promise1).method1().method2().method3()')
	expect(result6.code).toMatchSnapshot()
	const out6 = imbac.compile(result6.code, sourceId: 'test6')

test 'async with optional chaining' do
	const result7 = await build tsx-code7
	expect(result7.code).toContain('(await maybePromise)')
	expect(result7.code).toMatchSnapshot()
	const out7 = imbac.compile(result7.code, sourceId: 'test7')
