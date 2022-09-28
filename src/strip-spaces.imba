const newLine = /^\s*\n+\s*$/
###
# Strips spaces out of the SourceNode.
###

export def stripSpaces(node)
	node = stripPre(node)
	node = stripPost(node)
	node = stripMid(node)
	node = stripIndents(node)
	# debugger
	node
	# node = stripPost(node)

###
# Strip lines that only have indents
###

def stripIndents(node)
	let step = 0
	let indent = null

	replace node, {}, do(str)
		# Wait for "\n"
		if step == 0 or step == 1 and str.match(newLine)
			step = 1
			str

		# Followed by spaces (supress it)
		else if step is 1 and str.match(/^[ \t]+$/)
			indent = str
			step = 2
			""

		# Then merge the spaces into the next tode
		else if step is 2
			step = 1
			if str.match(newLine) then str else indent + str
		else
			step = 0
			str

###
# Strip beginning newlines.
###

def stripPre(node)
	# const _break = self._break
	# console.log "b", self
	replace node, {}, do(str)
		if str.match(newLine)
			""
		else
			this._break()
			str

###
# Strip ending newlines.
###

def stripPost(node)
	# const _break = self._break
	replace node, reverse: true, do(str)
		if str.match(newLine)
			""
		else
			this._break()
			# "{str}\n"
			str

###
# Strip triple new lines.
###

def stripMid(node)
	let streak = 0

	replace node, {}, do(n)
		if n == "\n"
			streak += 1
		else if n.match(/^\s*$/)
			# pass
			undefined
		else
			streak = 0

		if streak >= 3 then "" else n

###
# Walk and replace.
#
#     replace node, {}, (str) ->
#       if str is "true"
#         "replacement"
#       else
#         str
###

def replace(node, options = {}, fn)
	let broken = false

	let ctx = _break: (do broken = true)

	let walk = do(node, options = {}, fn)
		let range = []
		# console.log "children", {node}
		for n, i in (node.children or [])
			if options.reverse
				range.unshift i
			else
				range.push i

		for i in range
			return node if broken
			const child = node.children[i]

			if !child
				# pass
				undefined
			else if child.children
				walk child, options, fn

			else
				let output = fn.call ctx, child
				node.children[i] = output

		node

	walk.call ctx, node, options, fn
