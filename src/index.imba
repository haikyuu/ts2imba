import TransformerBase from './lib/transforms/base'
import { buildError } from './helpers'
import Builder from './builder'
import * as acorn from "acorn"
import * as walk from "acorn-walk"
import jsx from "acorn-jsx"
import postcss from 'postcss'
import tailwindcss from 'tailwindcss'
import cssnano from 'cssnano'

import CommentTransformer from './lib/transforms/comments'
import ReturnTransformer from './lib/transforms/returns'
import TagDeclarationTransformer from './lib/transforms/tags'
import TailwindTransformer from './lib/transforms/tailwind'
import LoopsTransformer from './lib/transforms/loops'
import MembersTransformer from './lib/transforms/members'
import ObjectsTransformer from './lib/transforms/objects'

import extractReactComponents from './h2r'
# import FunctionTransformer from './lbi/transforms/functions'
# import esbuild from 'esbuild-wasm'

export def parseJS(source, options)
	try
		let comments = []
		const parsed = acorn.Parser.extend(jsx()).parse(source, {
			sourceType: "module", 
			ecmaVersion: 2022, 
			onComment: comments,
			ranges: true,
			locations: true,
			...options
		})
		# Manually attach comments to the AST
		parsed.comments = comments
		console.log "DEBUG: Manual comment attachment, found", comments.length, "comments"
		parsed
	catch error
		throw buildError(error, source, options.filename)

export def generate(ast, options)
	new Builder(ast, options).get()

let esbuild
def strip-types(source)
	unless esbuild
		if $node$
			esbuild = await import('esbuild')
		else
			esbuild = await import('esbuild-wasm')
			# const esbuildUrl = 'https://esm.sh/esbuild-wasm@0.14.47/esbuild.wasm'
			const esbuildUrl = await import('esbuild-wasm/esbuild.wasm?url')

			await esbuild.initialize({wasmURL: esbuildUrl})

	const esbuild_options =
		jsx: "preserve"
		loader: "tsx"
		minify: no
		treeShaking: no
		tsconfigRaw: '{"compilerOptions": { "preserveValueImports": true }}'

	const without_types = await esbuild.transform(source, esbuild_options)
	without_types
export def build(source, options = {})
	options.filename ||= 'input.js'
	options.source = source
	let components
	if options.html
		components = await extractReactComponents(source, {componentType: 'class'})
		let res = []
		for own k,source of components
			res.push await build-tsx(source, options)
			# res.push await {code: source}
			# res.push source
		L res.map(do $1.code).join('\n')
		return {code: res.map(do $1.code).join('\n')}
	build-tsx(source, options)

def build-tsx(source, options = {})
	let __css = '@tailwind base;\n@tailwind components;\n@tailwind utilities;\n'
	let { css: parsedCSS } = await postcss([

		tailwindcss(content: [{ raw: source }]),
		cssnano()
	]).process(__css, {from: undefined})
	options.parsedCSS = parsedCSS
	let warnings
	options.trackComments = yes
	
	# Skip type stripping if source doesn't contain TypeScript syntax
	let hasTypeScript = /\b(interface|type|enum|namespace|declare|as\s+\w+|:\s*\w+|<\w+>|\?\s*:)/.test(source)
	let src
	if hasTypeScript
		src = await strip-types(source)
		console.log "DEBUG: TypeScript detected, stripped types"
	else
		src = { code: source }
		console.log "DEBUG: No TypeScript detected, preserving original source"
	
	console.log "DEBUG: Original source:", source
	console.log "DEBUG: Final source for parsing:", src.code
	let ast = await parseJS(src.code, options)
	console.log "DEBUG: AST comments:", ast.comments
	#
	{ast, warnings} = transform(ast, options)
	const res = generate(ast, options)
	{code:res.code, ast, warnings}

###*
 transform() : js2coffee.transform(ast, [options])
 Mutates a given JavaScript syntax tree `ast` into a CoffeeScript AST.

     ast = js2coffee.parseJS('var a = 2;')
     result = js2coffee.transform(ast)

     result.ast
     result.warnings

 This performs a few traversals across the tree using traversal classes
 (TransformerBase subclasses).

 These transformations will need to be done in multiple passes. The earlier
 steps (function, comment, etc) will make drastic modifications to the tree
 that the other transformations will need to pick up.
###
export def transform(ast, options = {})
	let ctx = {}
	def run(classes)

		TransformerBase.run(ast, options, classes, ctx)
	let comments = not (options.comments == false)

	# Injects comments into the AST as BlockComment and LineComment nodes.
	run [
		CommentTransformer
	] if comments

	# Moves named functions to the top of the scope.
	run [
		TailwindTransformer
	# 	FunctionTransformer
	]

	# # Everything else -- these can be done in one step without any side effects.
	run [
	# 	require('./lib/transforms/exponents')
	# 	require('./lib/transforms/ifs')
	# 	require('./lib/transforms/iife')
	# 	require('./lib/transforms/literals')
		LoopsTransformer
		MembersTransformer # wip
	# 	require('./lib/transforms/members')
		ObjectsTransformer
	# 	require('./lib/transforms/binary')
	# 	require('./lib/transforms/empty_statements')
	# 	require('./lib/transforms/others')
	# 	require('./lib/transforms/precedence')
		TagDeclarationTransformer
		ReturnTransformer
	# 	require('./lib/transforms/switches')
	# 	require('./lib/transforms/unsupported')
	]

	# # Consolidate nested blocks -- block nesting can be a side effect of the
	# # transformations above
	# run [
	# 	require('./lib/transforms/blocks')
	# ]

	{ ast, warnings: ctx.warnings }


export default Builder
