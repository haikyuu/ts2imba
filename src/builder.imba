import { stripSpaces } from './strip-spaces'
import { areQuotesRedundant, commaDelimit, joinLines, quote, prependAll, space, delimit, newline, toIndent, buildError } from './helpers'
import * as acorn from "acorn"
import type {Node} from 'acorn'
import * as acorn-walk from "acorn-walk"
import jsx from "acorn-jsx"
import SS from 'css'
import {SourceNode} from "source-map"

export class BaseBuilder
	root\Node
	options
	path = []
	def constructor(root\Node, options = {})
		root = root
		options = options
	
	def makeParams(params, defaults = [])
		let list = []
		# Account for defaults ("function fn(a = b)")
		for param, i in params
			if defaults[i]
				let _def = walk(defaults[i])
				list.push [walk(param), ' = ', _def]
			else
				list.push walk(param)

		if params.length
			[ '(', delimit(list, ', '), ')']
		else
			[]


	def get
		let node = run!
		node = stripSpaces(node)
		let result = node.toStringWithSourceMap!
		# result.code = result.code.replace(/\n\t*\n/g, "\n")
		result.code += "\n" unless result.code.endsWith("\n")
		result
	def run
		walk root
	
	def walk(node\Node, type)
		let out
		# when you get an error saying 
		# Cannot read properties of undefined (reading 'path')
		# make sure to transform arr.map(walk) to arr.map do walk($1)
		let oldLength = path.length
		path.push(node)

		type = undefined if typeof type != 'string'
		type ||= node.type
		let ctx = { path: path, type: type, parent: path[-2] }

		# check for a filter first -- not really necessary anymore
		# filters = filters?[type]
		# if filters?
		#   node = filter(node) for filter in filters

		# check for the main visitor
		let fn = this[type]
		if fn
			out = fn.call(this, node, ctx)
			out = decorator(node, out) if decorator
		else
			out = onUnknownNode(node, ctx)

		path.splice(oldLength)
		out
	def syntaxError(node\Node, description)
		const err = 
			start: node.start
			end: node.end
			description: description
		error = buildError
			err
			options.source, 
			options.filename
		throw new Error error.message
	def onUnknownNode(node, ctx)
		console.log "node unsupported", node, ctx
		syntaxError(node, "{node.type} is not supported")

	def decorator(node, output)
		new SourceNode
			undefined,
			undefined,
			options.filename,
			output


export default class Builder < BaseBuilder
	_indent = 0
	def constructor(root\Node, options = {})
		super root, options
	
	###*
	 indent():
	 Indentation utility with 3 different functions.
	
	 - `@indent(-> ...)` - adds an indent level.
	 - `@indent([ ... ])` - adds indentation.
	 - `@indent()` - returns the current indent level as a string.
	
	 When invoked with a function, the indentation level is increased by 1, and
	 the function is invoked. This is similar to escodegen's `withIndent`.
	
	     @indent =>
	       [ '...' ]
	
	 The past indent level is passed to the function as the first argument.
	
	     @indent (indent) =>
	       [ indent, 'if', ... ]
	
	 When invoked with an array, it will indent it.
	
	     @indent [ 'if...' ]
	     => [ '  ', [ 'if...' ] ]
	
	 When invoked without arguments, it returns the current indentation as a
	 string.
	
	     @indent()
	###
	def indent(fn)
		if fn isa Function
			let previous = indent!
			_indent += 1
			let result = fn(previous)
			_indent -= 1
			result
		# elif fn == -1
		# 	let tab = toIndent(options.indent)
		# 	Array(_indent).join(tab)
		else if fn
			[ indent!, fn ]
		else
			let tab = toIndent(options.indent)
			Array(_indent + 1).join(tab)

	def Program(node\Node)
		this.BlockStatement node

	def BlockStatement(node\Node)
		makeStatements(node, node.body)

	def MethodDefinition(node, ctx)
		let params = makeParams(node.value.params, node.value.defaults)
		let expr = indent do(i)
			["def"," ", walk(node.key) , params, "\n", walk(node.value.body) ]


	def JSXExpressionContainer(node\Node, ctx)
		if ctx.parent.type == 'JSXElement'
			[walk(node.expression), "\n"]
		else
			if node.expression.type == 'ArrowFunctionExpression' or node.expression.type == 'FunctionExpression'
				const walked = walk(node.expression)
				if "{walked}".trim().indexOf("\n") == -1
					["(", walked, ")"]
				else
					["(", walked, indent().replace("\t", ""), ")"]
			else
				[walk(node.expression)]
	def ImportNamespaceSpecifier(node)
		["* as ", walk(node.local)]
	def ObjectPattern(node\Node, ctx)
		let _in_function
		if ctx.parent.type in ['FunctionExpression', 'ArrowFunctionExpression']
			_in_function = yes
		const list = node.properties.map do 
			$1._in_function = _in_function
			walk($1)
		let params = delimit(list, ', ')
		['{', params , '}']
	def RestElement(node, ctx)
		["...", walk(node.argument)]
	def JSXMemberExpression(node)
		# node.object.name = node.object.name.toLowerCase!
		# node.property.name = node.property.name.toLowerCase!
		[walk(node.object), '-', walk(node.property)]
	def ArrayPattern(node)
		["[", delimit(node.elements.map(do walk $1), ', '), ']']
	def ImportDefaultSpecifier(node)
		[ walk(node.local) ]
	def ExportNamedDeclaration(node)
		if node.specifiers..length
			let specifiers = indent do
				let props = node.specifiers.map do walk $1
				[ "\n", joinLines(props, indent()) ]

			const exported = paren [ '{', specifiers, '\n', indent(), '}' ]
			return ['export ', exported]
		else
			['export ', walk(node.declaration)]
	def ExportSpecifier(node, ctx)
		if node.local.name == node.exported.name or node.local..left..name == node.exported.name
			space [walk node.local]
		else
			space [ walk(node.local), "as", walk(node.exported) ]
	def SpreadElement(node)
		['...', walk(node.argument)]
	def ImportSpecifier(node)
		let local = node.local.name
		let imported = node.imported.name
		if imported == local
			[local]
		else
			["{imported} as {local}"]
	def ImportDefaultSpecifier(node)
		node.local.name

	def ImportDeclaration(node)
		return ["import", " ",walk(node.source), "\n"] unless node.specifiers.length > 0
		# let specifiers = node.specifiers.map(do walk $1)
		let namedImportSpecifiers = node.specifiers.filter do $1.type != 'ImportDefaultSpecifier'
		const defaultImportSpecifier = node.specifiers.find do $1.type == 'ImportDefaultSpecifier'
		let specifiers = []
		specifiers.push walk(defaultImportSpecifier) if defaultImportSpecifier
		const walkedNamed = namedImportSpecifiers.map do walk $1
		specifiers = specifiers.concat ['{',delimit(walkedNamed, ','), '}'] if namedImportSpecifiers.length > 0
		if defaultImportSpecifier and namedImportSpecifiers.length == 0
			["import", " ", walk(defaultImportSpecifier), " from ", walk(node.source), "\n" ]
		elif !defaultImportSpecifier and namedImportSpecifiers.length > 0
			["import", ' ', '{', delimit(walkedNamed, ','), '}', " from " , walk(node.source), "\n" ]
		else
			["import", ' ',walk(defaultImportSpecifier), ", ", '{', delimit(walkedNamed, ','), '}', " from " , walk(node.source), "\n" ]
		
	def JSXFragment(node\ourceNode)
		let expr = indent do(_indent)
			let children = node.children.filter do(n)
				return no if n.type == 'JSXText' and !n.value.trim!
				yes
			const walked-children = children.map do 
				[indent(), walk $1]
			let indented-children = walked-children
			let opening = walk node.openingFragment
			if children.length
				[opening, "\n", indented-children]
			else
				[opening, "\n"]
		expr
	def ConditionalExpression(node)
		[walk(node.test), " ? ", walk(node.consequent), " : ", walk(node.alternate)]

	def VariableDeclaration(node\Node)
		# split declarations, 
		let decls = node.declarations.map do {...node, declarations: [$1]}
		node.kind = "let" if node.kind == 'var'
		let declarators = decls.map do [node.kind, " ", walk $1.declarations[0]]
		# delimit(declarators, indent!)
	
	def ThisExpression(node)
		if node._prefix
			[ "" ]
		else
			[ "this" ]
	def DebuggerStatement(node)
		["debugger", "\n"]
	def ContinueStatement(node)
		["continue", "\n"]
	def BreakStatement(node)
		["break", "\n"]
	def ThrowStatement(node)
		[ "throw ", walk(node.argument), "\n" ]
	def ForOfStatement(node, ctx)
		# debugger
		const left = if node.left..type == 'VariableDeclaration'
			walk(node.left.declarations[0].id)
		else
			walk(node.left)

		indent do ["for ", left, " in ", walk(node.right),"\n", walk(node.body)]

	def ChainExpression(node, ctx)
		walk(node.expression)

	def ForInStatement(node, ctx)
		# debugger
		const left = if node.left..type == 'VariableDeclaration'
			walk(node.left.declarations[0].id)
		else
			walk(node.left)

		indent do ["for own ", left, " of ", walk(node.right),"\n", walk(node.body)]

	def VariableDeclarator(node)
		let re
		if node.init
			re = [ walk(node.id), ' = ', newline(walk node.init) ]
			if node.init.type == 'FunctionExpression'
				# Space out 'a = ->'
				re = [ indent!, re, "\n" ]
		else
			re = [ walk(node.id), "\n"]
		re

	def Identifier(node)
		[ node.name ]
	def WhileStatement(node)
		[ "while ", walk(node.test), "\n", makeLoopBody(node.body) ]

	# Increment (`a++`)
	def UpdateExpression(node)
		if node.prefix
			[ node.operator, walk(node.argument) ]
		else
			[ walk(node.argument), node.operator ]

	def AssignmentExpression(node)
		let re = paren space [
			walk(node.left)
			node.operator
			walk(node.right)
		]

		# Space out 'a = ->'
		if node.right.type == 'FunctionExpression'
			re = [ "\n", indent(), re, "\n" ]
		re

	def NewExpression(node)
		let callee = [ walk(node.callee) ]
		# let callee = if node.callee..type == 'Identifier'
		# 	[ walk(node.callee) ]
		# else
		# 	[ '(', walk(node.callee), ')' ]

		let args = if node.arguments..length
			const a = makeSequence(node.arguments)
			if node.arguments.length == 1 and (node.arguments[0].type == "ArrowFunctionExpression" or node.arguments[0].type == "FunctionExpression")
				[ ' ', a ]
			else 
				[ '(', a , ')' ]
		else
			[]

		paren [ "new ", callee, args ]

	def IfStatement(node)
		let els
		let alt = node.alternate
		if alt..type == 'IfStatement'
			els = indent [ "else ", walk(node.alternate, 'IfStatement') ]
		else if alt..type is 'BlockStatement'
			els = indent do(i) [ i, "else", "\n", walk(node.alternate) ]
		else if alt
			els = indent do(i) [ i, "else", "\n", indent(walk(node.alternate)) ]
		else
			els = []

		indent do(i)
			let test = walk(node.test)
			let consequent = walk(node.consequent)
			if node.consequent.type != 'BlockStatement'
				consequent = indent(consequent)

			let word = if node._negative then 'unless' else 'if'

			[ word, ' ', test, "\n", consequent, els ]

	def TaggedTemplateExpression(node\Node)
		debugger
		throw "tagged not supp"
	def ArrowFunctionExpression(node\Node)
		let params = makeParams(node.params, node.defaults)
		
		const expr = if node.body.type == 'BlockStatement'
			indent do 
				const walked = walk(node.body)
				if "{walked}".trim().indexOf("\n") === -1
					["do", params, " ", "{walked}".trim() ]
				else
					["do", params, "\n", walked ]
		else
			["do", params," ", walk(node.body)]
		if node._parenthesized
			[ "(", expr, indent(), ")" ]
		else
			expr
		
	def FunctionExpression(node, ctx)
		params = makeParams(node.params, node.defaults)

		expr = indent do [ "do", params, "\n", walk(node.body) ]

		if node._parenthesized
			[ "(", expr, indent(), ")" ]
		else
			expr

	def AwaitExpression(node, ctx)
		["await ", walk(node.argument)]

	def AssignmentPattern(node, ctx)
		return [walk(node.left), ' = ', walk(node.right)]

	def TryStatement(node)
		# block, handler, finalizer
		let _try = indent do [ "try", "\n", walk(node.block) ]
		let _catch = if node.handler then indent do(_indent) [ _indent, walk(node.handler) ] else []
		let _finally = if node.finalizer then indent do(_indent) [ _indent, "finally", "\n", walk(node.finalizer) ] else []

		[ _try, _catch, _finally ]

	def CatchClause(node)
		let param = if node.param then walk(node.param) else []
		[ "catch ", param, "\n", walk(node.body) ]

	def SwitchStatement(node)
		let body = indent do makeStatements(node, node.cases)
		let item = walk(node.discriminant)

		if node.discriminant.type == 'ConditionalExpression'
			item = [ "(", item, ")" ]

		[ "switch ", item, "\n", body ]
	def SwitchCase(node)
		let left = if node.test
			[ "when ", walk(node.test) ]
		else
			[ "else" ]

		let right = indent do makeStatements(node, node.consequent)

		[ left, "\n", right ]

	def ArrayExpression(node, ctx)
		let items = node.elements.length
		let isSingleLine = items < 3

		if items == 0
			[ "[]" ]
		else if isSingleLine 
			[ "[", delimit(node.elements.map(do walk $1), ', '), "]" ]
		else
			indent do(_indent)
				let elements = node.elements.map do(e) newline walk(e)
				let contents = prependAll(elements, indent())
				[ "[", "\n", contents, _indent, "]" ]
	
	def TemplateLiteral(node)
		const newlines? = node.quasis.find do $1.value.raw.includes("\n")
		let result = []
		debugger
		if newlines?
			result.push '"""'
			unless node.quasis[0]..value.raw.indexOf("\n") == 0
				result.push '\n'
		else
			result.push '"'
		const all = node.quasis.concat(node.expressions)
		all.sort do $1.start > $2.start
		for part in all
			if part.type === 'TemplateElement'
				result.push(walk part)
			else
				result.push('{', walk(part), '}')

		if newlines?
			result.push '\n"""'
		else
			result.push '"'
		result
	def TemplateElement(node)
		[node.value.raw]

	def Literal(node, ctx)
		if (typeof node.value) == 'string'
			if areQuotesRedundant(node) and ctx.parent..type == 'Property' and ctx.parent.key.start == node.start
				[node.value]
			else
				[quote(node.value)]
		else 
			["{node.value}"]
	def JSXElement(node)
		let expr = indent do(_indent)
			let children = node.children.filter do(n)
				return no if n.type == 'JSXText' and !n.value.trim!
				yes
			const walked-children = children.map do 
				[indent(), walk $1]
			let indented-children = walked-children
			let opening = walk node.openingElement
			if children.length
				[opening, "\n", indented-children]
			else
				[opening, "\n"]
		expr
	# def JSXClosingElement(node)
	# 	return ["\n"]
	def MetaProperty(node)
		["{walk node.meta}.{walk node.property}"]

	def ImportExpression(node)
		["import({walk node.source})"]

	def JSXOpeningElement(node)
		let attributes = node.attributes.map do walk $1
		# let sp = node.attributes.length ? " ": ""
		["<{walk(node.name)}", attributes, ">"]
	def JSXOpeningFragment(node)
		let attributes = node.attributes.map do walk $1
		# let sp = node.attributes.length ? " ": ""
		["<", attributes, ">"]
	def JSXAttribute(node)
		console.log "unhandled classes", node.imba..unhandled-classes if node.imba..unhandled-classes.length
		if node.imba..inline-styles..length
			[" [{node.imba.inline-styles.join(' ')}]"]
		elif node.value
			[" {walk node.name}", "=", walk node.value]
		else
			[" {walk node.name}"]
	def JSXText(node)
		# new lines, tabs and spaces have no meaning in jsx text
		const val = node.value.trim!.replace(/\s+/g, ' ')
		[ quote(val), "\n" ]

	def JSXIdentifier(node)
		[ node.name ]
	def ClassDeclaration(node, ctx)
		# 
		let kind = node.kind or "class"
		let expr = indent do(i)
			if node.superClass
				[kind," ", walk(node.id) , '<', walk(node.superClass), "\n", walk(node.body) ]
			else
				[kind," ", walk(node.id), "\n", walk(node.body) ]
	def RenderMethodInline(node, ctx)
		walk node.body
	def ClassBody(node, ctx)
		# 
		const walked = node.body.map do walk $1
		let ret = indent walked
		ret

	def ExportDefaultDeclaration(node)
		# 
		return space ["export", "default", walk(node.declaration)]
	def FunctionDeclaration(node, ctx)
		
		# TODO: if return type is jsx element, then create a tag instead
		let params = makeParams(node.params, node.defaults)
		let expr = indent do(i)
			["def"," ", walk(node.id) , params, "\n", walk(node.body) ]

		if node._parenthesized
			[ "(", expr, indent(), ")" ]
		else
			expr

	def ReturnStatement(node)
		if node.argument
			space [ "return", [ walk(node.argument), "\n" ] ]
		else
			[ "return", "\n" ]

	def ExpressionStatement(node)
		newline walk(node.expression)
	def Property(node, ctx)
		if node.kind != 'init'
			throw new Error "Property: not sure about kind {node.kind}"

		if ctx.parent.type == 'ObjectPattern' and node._in_function and (node.key.name == node.value.name or node.key..left..name == node.value.name)
			space [walk node.value]
		else
			space [ [walk(node.key), ":"], walk(node.value) ]

	def ObjectExpression(node, ctx)
		let props = node.properties.length
		let isBraced = node._braced
		const oneline = ctx.parent..type == 'JSXExpressionContainer'


		# Empty
		if props == 0 
			[ '{}' ]

		# Not yet working in Imba for objects: like <self> <div>
		# Single prop ({ a: 2 }) e.g: {a: {b: {c:2, d: 3}}}
		# --> a: b:
		# -->    c:2
		# -->    d:3
		elif (props == 1 and ctx.parent.type != 'Property') or oneline
			props = node.properties.map do walk $1
			if isBraced or oneline
				paren ['{', delimit(props, ', '), '}']
			else
				paren [ props ]

		# Last expression in scope (`function() { ({a:2}); }`)
		elif node._last
			props = node.properties.map do walk $1
			delimit(props, [ "\n", indent() ])
		# Multiple props ({ a: 2, b: 3 })
		else
			props = indent do
				props = node.properties.map do walk $1
				[ "\n", joinLines(props, indent()) ]

			if isBraced
				paren [ '{', props, '\n', indent(), '}' ]
			else
				paren [ props ]

	def CallExpression(node, ctx)
		let callee = walk(node.callee)
		const funcIndex = node.arguments.findIndex do $1.type == "ArrowFunctionExpression" or $1.type == 'FunctionExpression'
		let argsWithoutFunc = node.arguments.map do(arg, i)
			return arg unless i == funcIndex
			return {...arg, type: "CallbackPlaceholder"}
		# debugger
		if funcIndex > -1
			if funcIndex === node.arguments.length - 1
				argsWithoutFunc = argsWithoutFunc.slice 0, -1
			const func = node.arguments[funcIndex]
			let args = paren(makeSequence(argsWithoutFunc), yes)
			args = "" if argsWithoutFunc.length === 0
			return [callee, args, " ", walk func]
		let list = makeSequence argsWithoutFunc
		node._isStatement = ctx.parent.type == 'ExpressionStatement'

		let hasArgs? = list.length > 0
		if node._isStatement and hasArgs?
			space [ callee, list ]
		elif node.arguments.length == 1 and node.arguments[0].type == 'ObjectExpression'
			space [ callee, list ]
		else
			[ callee, paren(list, yes) ]

	def CallbackPlaceholder
		["&"]


	def LogicalExpression(node)
		let opers =
			'||': 'or'
			'&&': 'and'

		let oper = opers[node.operator]
		paren [ walk(node.left), ' ', oper, ' ', walk(node.right) ]

	# Operator (+)
	def BinaryExpression(node)
		let operator = node.operator
		# operator = 'of' if operator == 'in'
		paren space [ walk(node.left), operator, walk(node.right) ]

	def MemberExpression(node, ctx)
		const optional? = node.optional

		let right = if node.computed
			if optional?
				['..', '[', walk(node.property), ']' ]
			else
				[ '[', walk(node.property), ']' ]
		else if node._prefixed
			if optional?
				['..', walk(node.property) ]
			else
				[ walk(node.property) ]
		else
			if optional?
				[ '..', walk(node.property) ]
			else
				[ '.', walk(node.property) ]

		let expr = paren [ walk(node.object), right ]
		if ctx.parent.type == 'Property'
			return ["[", expr ,"]"]
		expr

	def UnaryExpression(node)
		let isNestedUnary = do node.argument.type == 'UnaryExpression'
		let isWord = do (/^[a-z]+$/i).test(node.operator)
		if node.operator == 'void' and node.argument..value == 0
			["undefined"]
		elif isNestedUnary() or isWord()
			paren [ node.operator, ' ', walk(node.argument) ]
		else
			paren [ node.operator, walk(node.argument) ]

	###*
	makeSequence():
	Builds a comma-separated sequence of nodes.
	TODO: turn this into a transformation
	###
	def makeSequence(list)
		for arg, i in list
			unless let isLast = i == (list.length - 1)
				if arg.type == "FunctionExpression"
					arg._parenthesized = true
				else if arg.type == "ObjectExpression"
					arg._braced = true

		commaDelimit list.map do walk $1
	###*
	# paren():
	# Parenthesizes if the node's parenthesize flag is on (or `parenthesized` is
	# true)
	###

	def paren(output, parenthesized, cb)
		parenthesized ||= path[path.length - 1].._parenthesized
		let isBlock = output.toString().match /\n$/

		if parenthesized
			if isBlock
				[ '(', output, indent(cb), ')' ]
			else
				[ '(', output, ')' ]
		else
			output
	def makeLoopBody(body)
		let isBlock = body..type == 'BlockStatement'

		# const walked-body = body.body.map do walk $1
		# TODO: move this transformation to the lib/transforms/
		if not body or (isBlock and body.body.length == 0)
			indent do [ indent(), "continue", "\n" ]
		else if isBlock
			indent do walk(body)
		else
			indent do [ indent(), walk(body) ]

	def makeStatements(node\Node, body)
		const walked = body.map do walk $1
		let ret = []
		for item, i in walked
			if body[i].type != "BlockStatement"
				ret.push indent()
			ret.push item
		ret






