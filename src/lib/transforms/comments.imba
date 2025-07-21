import TransformerBase from './base'

###
# Injects comments as nodes in the AST. This takes the comments in the
# `Program` node, finds list of expressions in bodies (eg, a BlockStatement's
# `body`), and injects the comment nodes wherever relevant.
#
# Comments will be injected as `BlockComment` and `LineComment` nodes.
###

export default class CommentsTransformer < TransformerBase
	# Disable the stack-tracking for now
	ProgramExit= null
	FunctionExpression= null
	FunctionExpressionExit= null
	comments

	def Program(node)
		comments = node.comments || []
		updateCommentTypes()
		node.body = addCommentsToList([0,Infinity], node.body)
		node

	def BlockStatement(node)
		injectComments(node, 'body')

	def SwitchStatement(node)
		injectComments(node, 'cases')

	def SwitchCase(node)
		injectComments(node, 'consequent')

	def BlockComment(node)
		convertCommentPrefixes(node)

	###
	# Updates comment `type` as needed. It changes *Block* to *BlockComment*, and
	# *Line* to *LineComment*. This makes it play nice with the rest of the AST,
	# because "Block" and "Line" are ambiguous.
	###

	def updateCommentTypes
		for c in comments
			switch c.type
				when 'Block' then c.type = 'BlockComment'
				when 'Line'  then c.type = 'LineComment'

	###
	# Injects comment nodes into a node list.
	###

	def injectComments(node, body = 'body')
		node[body] = addCommentsToList(node.range, node[body])
		node

	###
	# Delegate of `injectComments()`.
	#
	# Checks out the `@comments` list for any relevants comments, and injects
	# them into the correct places in the given `body` Array. Returns the
	# transformed `body` array.
	###

	def addCommentsToList(range, body)
		return body unless range

		let list = []
		let left = range[0]
		let right = range[1]

		let findComments = do(left, right)
			comments.filter do(c)
				c.range[0] >= left and c.range[1] <= right

		if body.length > 0
		# look for comments in left..item.range[0]
		# (ie, before each item)
		for item, i in body
			if item.range
				let newComments = findComments(left, item.range[0])
				list = list.concat(newComments)

			list.push item

			if item.range
				left = item.range[1]

		# look for the final one (also accounts for empty bodies)
		let newComments = findComments(left, right)
		list = list.concat(newComments)

		list

	###
	# Changes JS block comments into CoffeeScript block comments.
	# This involves changing prefixes like `*` into `#`.
	###

	def convertCommentPrefixes(node)
		let lines = node.value.split("\n")
		let inLevel = node.loc.start.column

		lines = lines.map do(line, i)
			let isTrailingSpace = i == lines.length-1 and line.match(/^\s*$/)
			let isSingleLine = i == 0 and lines.length == 1

			# If the first N characters are spaces, strip them
			let predent = line.substr(0, inLevel)
			if predent.match(/^\s+$/)
				line = line.substr(inLevel)

			if isTrailingSpace
				''
			else if isSingleLine
				line
			else
				line = line.replace(/^ \*/, '#')
				line + "\n"
		node.value = lines.join("")
		node
