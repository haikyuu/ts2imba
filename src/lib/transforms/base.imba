import {
	buildError,
	clone,
	replace,
	toIndent
} from '../../helpers'

###
# Extends a class `dest`'s prototype with those from other classes in `classes`.
# Throws an error if there's a clash.
###

def safeExtend(dest, classes)
	let added = {}
	# 
	classes.forEach do(klass)
		for key in Object.getOwnPropertyNames klass.prototype
			const fn = klass.prototype[key]
			if added[key] and key != 'constructor'
				dest.prototype[key] = chain(dest.prototype[key], fn)
			else
				dest.prototype[key] = fn
			added[key] = true
	
	dest

# Chains two Visitor functions together. Returns a function that will run the
# `old` function, and feed its output node to the `new` function.
#
#     class X extends TransformBase
#       CallExpression: (node) ->
#
#     class Y extends TransformBase
#       CallExpression: (node) ->
#
#     fn = chain(X::CallExpression, Y::CallExpression)
#
def chain(old, noo)
	do(node, ...args)
		let type = node.type
		let result = old.bind(this)(node, ...args)

		# If the `old` function modified the node type, don't continue.
		# This is the case for eg, CallExpression turning into BinaryExpression
		if result.type == type
			result = noo.bind(this)(result, ...args)

		result

###**
# TransformerBase:
# Base class of all transformation steps, such as [FunctionTransforms] and
# [OtherTransforms]. This is a thin wrapper around *estraverse* to make things
# easier, as well as to add extra features like scope tracking and more.
#
#     class MyTransform extends TransformerBase
#       Program: (node) ->
#         return { replacementNodeHere }
#
#       FunctionDeclaration: (node) ->
#         ...
#
#     ctx = {}
#     TransformerBase.run ast, options, [ MyTransform ], ctx
#
#     # result:
#     ast
#     ctx.warnings
#
# Each visitor is a method with the node type as the name.
#
#     class MyTransform extends TransformerBase
#       Literal: (node) ->
#         # do stuff with `node`
#         # return the replacement when done
#
#       FunctionDeclaration: (node) ->
#         # do stuff with `node` too
#
# From within the handlers, you can call some utility functions:
#
#     @skip()
#     @break()
#     @syntaxError(node, "'with' is not supported")
#     @warn(node, "warning goes here")
#
# You have access to these variables:
#
# ~ @depth: The depth of the current node
# ~ @node: The current node.
# ~ @controller: The estraverse instance
#
# It also keeps track of scope. For every function body it traverses into (eg:
# FunctionExpression.body), you get a `@ctx` variable that is only available
# from *within that scope* and the scopes below it.
#
# ~ @scope: the Node that is the current scope. This is usually a BlockStatement
#   or a Program.
# ~ @ctx: Context variables for the scope. You can store anything here and it
#   will be remembered for the current scope and the scopes below it.
#
# It also has a few hooks that you can override:
#
# ~ onScopeEnter: when scopes are entered (via `pushScope()`)
# ~ onScopeExit: when scopes are exited (via `popScope()`)
# ~ onEnter: enter of a node
# ~ onExit: exit of a node
# ~ onBeforeEnter: before the enter of a node
# ~ onBeforeExit: before the exit of a node
###

export default class TransformerBase
	options
	ast
	scopes
	warnings
	ctx
	depth
	controller
	node
	###
	# Run multiple transformations
	###
	static def run(ast, options, classes, ctx)
		# Combine `classes` into one mega-class
		class Xformer < TransformerBase

		safeExtend Xformer, classes

		# Run that
		let xform = new Xformer(ast, options)
		let result = xform.run()

		# Collect warnings into `ctx`, then return
		ctx.warnings ||= []
		ctx.warnings = ctx.warnings.concat(xform.warnings)
		result

	def constructor(ast, options)
		ast = ast
		options = options
		scopes = []
		ctx = { vars: [] }
		warnings = []

	###*
	# run():
	# Runs estraverse on `@ast`, and invokes functions on enter and exit
	# depending on the node type. This is also in change of changing `@depth`,
	# `@node`, `@controller` (etc) every step of the way.
	#
	#     new Transformer(ast).run()
	###
	def run
		recurse ast

	###*
	# recurse():
	# Delegate function of `run()`. See [run()] for details.
	#
	# This is sometimes called on its own to recurse down a certain path which
	# will otherwise be skipped.
	###

	def recurse(root)
		# let self = this
		depth = 0
		let runner = do(direction, _node, parent)
			let result
			node   = _node
			depth += if direction == 'Enter' then +1 else -1
			let fnName  = if direction == 'Enter' then "{node.type}" else "{node.type}Exit"
			
			self["onBefore{direction}"](node, parent) if self["onBefore{direction}"]
			result = self[fnName](node, parent) if self[fnName]
			self["on{direction}"](node, parent) if self["on{direction}"]
			result
		estraverse()().replace 
			root,
			enter: do(node, parent)
				self.controller = this
				runner("Enter", node, parent)
			leave: do(node, parent)
				runner("Exit", node, parent)

		root

	###*
	# skip():
	# Skips a certain node from being parsed.
	#
	#     class MyTransform extends TransformerBase
	#       Identifier: ->
	#         @skip()
	###

	def skip
		controller..skip()

	###*
	# remove():
	# Removes a node from the tree.
	#
	#     class MyTransform extends TransformerBase
	#       Identifier: ->
	#         @remove()
	###
	#
	def remove
		controller..remove()

	###*
	# estraverse():
	# Returns `estraverse`. It's monkey-patched to work with CoffeeScript ASTs.
	#
	#     @estraverse().replace ast, ...
	###

	def estraverse
		_estraverse ||= do
			let es = require('estraverse')
			es.VisitorKeys.CoffeeEscapedExpression = []
			es.VisitorKeys.CoffeeListExpression = ['test', 'body']
			es.VisitorKeys.CoffeePrototypeExpression = ['object', 'property', 'computed']
			es.VisitorKeys.CoffeeLoopStatement = ['body']
			es.VisitorKeys.CoffeeDoExpression = ['function']
			es.VisitorKeys.BlockComment = []
			# es.VisitorKeys.MethodDefinition = ['value', 'body']
			es.VisitorKeys.LineComment = []
			es.VisitorKeys.JSXFragment = ['children', 'openingElement']
			es.VisitorKeys.JSXElement = ['children', 'openingElement']
			es.VisitorKeys.JSXOpeningElement = ['attributes', 'name']
			es.VisitorKeys.JSXOpeningFragment = ['attributes', 'name']
			es.VisitorKeys.JSXAttribute = ['name', 'value']
			es.VisitorKeys.JSXExpressionContainer = []
			es.VisitorKeys.JSXMemberExpression = []
			es.VisitorKeys.JSXText = []
			es.VisitorKeys.JSXIdentifier = []
			es

	###*
	# pushStack() : @pushStack(node)
	# Pushes a scope to the scope stack. Every time the scope changes, `@scope`
	# and `@ctx` gets changed.
	###

	def pushStack(node)
		let [ oldScope, oldCtx ] = [ scope, ctx ]
		scopes.push [ scope , ctx ]
		ctx = clone(ctx)
		scope = node
		# 
		onScopeEnter(scope, ctx, oldScope, oldCtx) if onScopeEnter

	def popStack()
		
		let [ oldScope, oldCtx ] = [ scope, ctx ]
		[ scope, ctx ] = scopes.pop()
		
		onScopeExit(scope, ctx, oldScope, oldCtx) if onScopeExit

	###*
	# syntaxError() : @syntaxError(node, message)
	# Throws a syntax error for the given `node` with a given `message`.
	#
	#     @syntaxError node, "Not supported"
	###

	def syntaxError(node, description)
		err = buildError
			start: node.start,
			end: node.end,
			description: description,
			options.source,
			options.filename
		throw err

	###*
	# warn() : @warn(node, message)
	# Add a warning
	#
	#     @warn node, "Variable was defined twice"
	###

	def warn(node, description)
		warnings.push
			start: node.start
			end: node.end
			filename: options.filename
			description: description

	###*
	# Defaults: these are default handlers that will automatially change `@scope`.
	###

	def Program(node)
		pushStack node
		node

	def ProgramExit(node)
		popStack()
		node

	def FunctionExpression(node)
		pushStack node.body
		node
	def ArrowFunctionExpression(node)
		pushStack node.body
		node
	
	# Added
	def FunctionDeclaration(node)
		pushStack node.body
		node
	# def JSXElement(node)
	# 	
	# 	pushStack node.openingElement
	# 	node
	def MethodDefinition(node)
		pushStack node.body
		# recurse(node.body)
		node
	# def BlockStatement(node)
	# 	pushStack node.body
	# 	# recurse(node.body)
	# 	node
	# def ReturnStatement(node)
	# 	pushStack node.argument
	# 	# 
	# 	# recurse(node.body)
	# 	node
	# def ClassDeclaration(node)
	# 	pushStack node.body
	# 	node
	# def ClassBody(node)
	# 	popStack!
	# 	node

	# /Added
	# def FunctionExpressionExit(node)
	# 	popStack()
	# 	node

	def escapeJs(node, options = {})
		replace node,
			type: 'CoffeeEscapedExpression'
			_parenthesized: options.parenthesized
			raw: require('escodegen').generate(node)
			format:
				indent:
					style: toIndent(options.indent)


