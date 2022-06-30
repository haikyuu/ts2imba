import type {Node} from 'acorn'

export def buildError(err, source, file = '')
	return err if err.tsx2imba
	const {description} = err
	const line = 1
	const column = err.start or 0

	const heading = "{file}:{line}:{column}: {description}"
	const lines = source.split("\n")
	const min = 0
	const max = line 
	const digits = max.toString().length
	let length = 1
	# 
	length = Math.max(err.end - err.start, 1) if err.end
	const pad = do(s) Array(1 + digits - s.toString().length).join(" ") + s

	source = lines.slice(min, +max + 1 || 9e9).map do(line, i) "{pad(1 + i + min)}  {line}"
	source.push Array(digits + 3).join(" ") + Array(column+1).join(" ") + Array(length+1).join("^")
	source = source.join("\n")

	let message = heading + "\n\n" + source
	let _err = err
	err = new Error(message)
	err.message = message
	err.filename      = file
	err.description   = _err.description
	err.start         = { line, column }
	err.end           = _err.end
	err.sourcePreview = source
	err.tsx2imba     = true
	err

export def toIndent(ind = 'tab')
	if ind == 'tab' or ind == 't'
		"\t"
	elif typeof ind == 'string' and "#{+ind}" isnt ind
		ind
	else
		Array(+ind + 1).join " "

export def newline(srcnode\Node)
	if (/\n$/).test(srcnode.toString())
		srcnode
	else
		[ srcnode, "\n" ]

export def delimit(list, joiner)
	let newlist = []
	for item, i in list
		newlist.push(joiner) if i > 0
		newlist.push(item)
	newlist

export def space(list)
	list.reduce(&, []) do(newlist, item, i)
		if i == 0
			newlist.concat [ item ]
		elif item.toString().substr(0, 1) == "\n"
			newlist.concat [ item ]
		else
			newlist.concat [ ' ', item ]

export def prependAll(list, prefix)
	let newlist = []
	for item, i in list
		newlist.push(prefix)
		newlist.push(item)
	newlist


###*
# quote() : quote(string)
# Quotes a string with single quotes.
#
#     quote("hello")
#     => "'hello'"
###
export def quote(str)
	if typeof str == 'string'
		# escape quotes
		def format_char_code(char)
			let ret = char.charCodeAt(0).toString(16)
			let p = for i in [0 ... (4 - ret.length)]
				"0"
			ret = p.join('') + ret
			"\\u" + ret
		let re = str
			.replace(/\\/g, '\\\\')
			.replace(/'/g, "\\'")
			.replace(/\\"/g, '"')
			.replace(/\n/g, '\\n')
			.replace(/[\u0000-\u0019\u00ad\u200b\u2028\u2029\ufeff]/g, format_char_code)
		"\"{re}\""

	else
		JSON.stringify(str)

###*
# replace() : replace(node, newNode)
# Fabricates a replacement node for `node` that maintains the same source
# location.
#
#     node = { type: "FunctionExpression", range: [0,1], loc: { ... } }
#     @replace(node, { type: "Identifier", name: "xxx" })
###

export def replace(node, newNode)
	newNode.range = node.range
	newNode.loc = node.loc
	newNode

###*
# clone() : clone(object)
# Duplicates an object.
###

export def clone(obj)
	JSON.parse JSON.stringify obj


###*
# lastStatement() : lastStatement(body)
###

export def isComment(node)
	node.type == 'LineComment' or node.type == 'BlockComment'

export def lastStatement(body)
	for j in [0 .. body.length]
		let i = body.length - j
		let node = body[i]
		continue unless node
		if ! isComment(node)
			return node

###*
getReturnStatements():
Returns the final return statements in a body.
###

export def getReturnStatements(body)
	let node
	# Find the last pertinent statement
	if !body
		return
	elif body.length
		node = lastStatement(body)
	else
		node = body

	# See what it ==, recurse as needed
	if !node
		[]
	elif node.type is 'ReturnStatement'
		[ node ]
	elif node.type == 'FunctionDeclaration' or node.type == 'ArrowFunctionExpression'
		getReturnStatements node.body
	elif node.type == 'BlockStatement'
		getReturnStatements node.body
	elif node.type == 'IfStatement' and node.consequent and node.alternate
		let cons = getReturnStatements(node.consequent)
		let alt  = getReturnStatements(node.alternate)

		if cons.length > 0 and alt.length > 0
			cons.concat(alt)
		else
			[]
	else
		[]

###*
 joinLines() : joinLines(properties, indent)
 Joins multiple tokens as lines. Takes trailing newlines into
 account.

     joinLines(["a\n", "b", "c"], "  ")
     => [ "  ", "a\n", "  ", "b", "\n", "  ", "c" ]
###
export def joinLines(props, indent)
	let newlist = []

	for item, i in props
		newlist.push(indent)
		newlist.push(item)

		let isLast = (i != props.length - 1)
		if !item.toString().match(/\n$/) and isLast
			newlist.push "\n"

	newlist


###*
 commaDelimit() : commaDelimit(list)
 Turns an array of strings into a comma-separated list. Takes new lines into
 account.

     commaDelimit( [ 'a', 'b', 'c' ] )
     => 'a, b, c'
###
export def commaDelimit(list)
	let newlist = []
	for item, i in list
		if i > 0
			if /^\n/.test(item.toString())
				newlist.push(',')
			else
				newlist.push(', ')
		newlist.push(item)
	newlist

export def areQuotesRedundant(node) 
	/^[a-zA-Z_$][0-9a-zA-Z_$]*$/g.test node.value

###
# isLoop() : isLoop(node)
# Checks if a loop is forever
###
export def isLoop(node)
	not node.test or isTruthy(node.test)


###
# isTruthy() : isTruthy(node)
# Checks if a given node is truthy
###
export def isTruthy(node)
	node.type == 'Literal' and node.value
