import {build} from "../index"
import * as imbac from 'imba/compiler'

let single-line-code = '''
let a = `today is ${new Date()} but 1 + 1 = ${2}`
'''

test 'single line template literal' do
	const result = await build single-line-code
	expect(result.code).toMatchSnapshot()
	expect(result.code).toContain('"today is {new Date()} but 1 + 1 = {2}"')
	const out = imbac.compile(result.code, sourceId: 'test')
	console.log("ss", out)
	expect(out.js).toBeDefined()

let multi-line-code = '''
let b = `this is line 1
and this is ${name} on line 2`
'''

test 'multi line template literal' do
	const result = await build multi-line-code
	expect(result.code).toMatchSnapshot()
	expect(result.code).toContain('`this is line 1\nand this is {name} on line 2`')
	const out = imbac.compile(result.code, sourceId: 'test')
	expect(out.js).toBeDefined()

let complex-expressions-code = '''
let c = `result: ${a + b} and ${func(x, y)}`
'''

test 'template literal with complex expressions' do
	const result = await build complex-expressions-code
	expect(result.code).toMatchSnapshot()
	expect(result.code).toContain('"result: {a + b} and {func(x, y)}"')
	const out = imbac.compile(result.code, sourceId: 'test')
	expect(out.js).toBeDefined()

let nested-template-code = '''
let d = `outer ${`inner ${value}`} end`
'''

test 'nested template literals' do
	const result = await build nested-template-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'test')
	expect(out.js).toBeDefined()

let empty-template-code = '''
let e = ``
'''

test 'empty template literal' do
	const result = await build empty-template-code
	expect(result.code).toMatchSnapshot()
	expect(result.code).toContain('""')
	const out = imbac.compile(result.code, sourceId: 'test')
	expect(out.js).toBeDefined()

let only-expressions-code = '''
let f = `${x}${y}${z}`
'''

test 'template literal with only expressions' do
	const result = await build only-expressions-code
	expect(result.code).toMatchSnapshot()
	expect(result.code).toContain('"{x}{y}{z}"')
	const out = imbac.compile(result.code, sourceId: 'test')
	expect(out.js).toBeDefined()

let mixed-quotes-code = '''
let g = `He said "${message}" to me`
'''

test 'template literal with mixed quotes' do
	const result = await build mixed-quotes-code
	expect(result.code).toContain('"He said \\"{message}\\" to me"')
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'test')
	expect(out.js).toBeDefined()
