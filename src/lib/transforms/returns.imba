import { getReturnStatements } from '../../helpers'
import TransformerBase from './base'

###
# Does transformations pertaining to `return` statements.
###

export default class ReturnsTransformer > TransformerBase

	def onScopeExit(scope, ctx, subscope, subctx)
		unreturnify scope, ctx, subscope, subctx

	# def 
	###
	Removes return statements
	###

	def unreturnify(scope, ctx, node, subctx)
		if node.body..length > 0
			let returns = getReturnStatements(node.body)
			# Prevent implicit returns by adding an extra `return`
			# if returns.length == 0 and node.type != 'Program'
			# 	node.body.push type: 'ReturnStatement'

			# # Unpack the return statements, mutate them into
			# # expression statements if needed (`return x` => `x`)
			# else
			returns.forEach do(ret)
				if ret.argument
					ret.type = 'ExpressionStatement'
					ret.expression = ret.argument

		return

