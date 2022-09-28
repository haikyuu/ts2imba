
import { replace, isLoop } from '../../helpers'
import TransformerBase from  './base'

###
# Provides transformations for `while`, `for` and `do`.
###

export default class LoopsTransform < TransformerBase
	_for
	def ForStatement(node)
		# Keep track of the nesting of `for` loops
		_for ||= []
		_for.push node

		injectUpdateIntoBody(node)
		debugger
		convertForToWhile(node)

	def ForStatementExit(node)
		_for = _for.pop()
		delete _for._update
		node

	def ForInStatement(node)
		warnIfNoVar(node)

	def WhileStatement(node)
		convertWhileToLoop(node)

	def DoWhileStatement(node)
		convertDoWhileToLoop(node)

	def ContinueStatement(node, parent)
		injectUpdateIntoContinue(node, parent)

	###
	# In a `for` loop with an update statement, inject the update just
	# before the `continue`.
	#
	# This replaces the ContinueStatement with a block that groups the
	# update and continue together.
	###

	def injectUpdateIntoContinue(node, parent)
		_for = _for..[_for.length - 1]
		return node unless _for.._update

		skip()

		type: 'BlockStatement'
		body: [
			{ type: 'ExpressionStatement', expression: _for._update}
			node
		]

	###
	# Converts `do { x } while (y)` to `loop\  x\  break unless y`.
	###

	def convertDoWhileToLoop(node)
		block = node.body
		body = block.body

		body.push replace node.test,
			type: 'IfStatement'
			_negative: true
			test: node.test
			consequent:
				type: 'BreakStatement'

		replace node,
			type: 'CoffeeLoopStatement'
			body: block

	###
	# Produce a warning for `for (x in y)` where `x` is not `var x`.
	###

	def warnIfNoVar(node)
		if node.left.type != 'VariableDeclaration'
			warn node, "Using 'for..in' loops without 'var' can produce unexpected results" 
		node

	###
	# Converts a `for (x;y;z) {a}` to `x; while(y) {a; z}`.
	# Returns a `BlockStatement`.
	###

	def convertForToWhile(node)
		node.type = if isLoop(node)
			'CoffeeLoopStatement'
		else
			'WhileStatement'

		let i = node.init
		delete node.init
		if i
			type: 'BlockStatement'
			body: [
				{type: 'ExpressionStatement',expression: i}
				node
			]
		else
			node

	###
	# Converts a `while (true)` to a CoffeeLoopStatement.
	###
	def convertWhileToLoop(node)
		if isLoop(node)
			replace node,
				type: 'CoffeeLoopStatement'
				body: node.body
		else
			node

	###*
	# Injects a ForStatement's update (eg, `i++`) into the body.
	###
	def injectUpdateIntoBody(node)
		if node.update
			let statement =
				type: 'ExpressionStatement'
				expression: node.update
			# Ensure that the body is a BlockStatement with a body
			unless node.body
				node.body ||= { type: 'BlockStatement', body: [] }
			else if node.body.type != 'BlockStatement'
				old = node.body
				node.body = { type: 'BlockStatement', body: [ old ] }

			node.body.body = node.body.body.concat([statement])

			# leave it for `continue` to pick up
			node._update = node.update
			delete node.update
		node
