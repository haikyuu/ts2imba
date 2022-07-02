# const { replace } = require('../helpers')
import TransformerBase from './base'

###
# Performs transformations on `a.b` scope resolutions.
#
#     this.x            =>  x
#     x.prototype.y     =>  x::y
#     this.prototype.y  =>  ::y
#     function(){}.y    =>  (->).y
###

export default class MemberTransformer < TransformerBase

	def MemberExpression(node, ctx)
		transformThisToImplicitThis(node)
		braceObjectOnLeft(node)
		# replaceWithPrototype(node) or 
		parenthesizeObjectIfFunction(node)

	def CoffeePrototypeExpression(node)
		transformThisToImplicitThis(node)

	def CallExpression(node)
		parenthesizeCalleeIfFunction(node)

	###
	# Converts `this.x` into `x` for MemberExpressions.
	###

	def transformThisToImplicitThis(node)
		if node.object.type is 'ThisExpression'
			node._prefixed = true
			node.object._prefix = true
		node

	def braceObjectOnLeft(node)
		if node.object.type == 'ObjectExpression'
			node.object._braced = yes
		return


	###
	 Parenthesize function expressions if they're in the left-hand side of a
	 member expression (eg, `(-> x).toString()`).
	###
	def parenthesizeObjectIfFunction(node)
		if node.object.type in ['FunctionExpression', 'ArrowFunctionExpression']
			node.object._parenthesized = true
		node
	# Add () to function if immediately called --> `(do 1)()`
	def parenthesizeCalleeIfFunction(node)
		if node.callee.type in ['FunctionExpression', 'ArrowFunctionExpression']
			node.callee._parenthesized = true
		node

#   ###
#   # Replaces `a.prototype.b` with `a::b` in a member expression.
#   ###

#   replaceWithPrototype: (node) ->
#     isPrototype = node.computed is false and
#       node.object.type is 'MemberExpression' and
#       node.object.property.type is 'Identifier' and
#       node.object.property.name is 'prototype'

#     if isPrototype
#       recurse replace node,
#         type: 'CoffeePrototypeExpression'
#         object: node.object.object
#         property: node.property