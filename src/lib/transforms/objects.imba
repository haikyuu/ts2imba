import TransformerBase from './base'

###
Mangles the AST with various CoffeeScript tweaks.
###
export default class ObjectsTransform < TransformerBase

	def ArrayExpression(node)
		braceObjectsInElements(node)
		catchEmptyArraySlots(node)

	def ObjectExpression(node, parent)
		braceObjectInExpression(node, parent)
		braceObjectContainingRest(node, parent)

	def braceObjectContainingRest(node, parent)
		# debugger
		if node.properties.map(do $1.type).indexOf('SpreadElement') > -1
			node._braced = yes
		return
	###
	 Braces an object
	###
	def braceObjectInExpression(node, parent)
		let isLastInScope
		if parent.type == 'ExpressionStatement'
			isLastInScope = scope.body..[scope.body..length - 1] == parent

			if isLastInScope
				node._last = true
			else
				node._braced = true
		return

	###
	Ensures that an Array's elements objects are braced.
	###
	def braceObjectsInElements(node)
		for item in node.elements
			if item..type == 'ObjectExpression'
				item._braced = true
		node

	def catchEmptyArraySlots(node)
		if hasNullIn(node.elements)
			if options.compat
				escapeJs node
			else
				syntaxError node, 'Empty array slots are not supported in CoffeeScript'

	def hasNullIn(elements)
		for node in elements
			if node == null
				return yes
		no
