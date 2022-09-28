import { getReturnStatements } from '../../helpers'
import TransformerBase from './base'

###
# Does transformations pertaining to `return` statements.
###

export default class TagsTransformer > TransformerBase

	# def onScopeEnter(scope, ctx, subscope, subctx)
	# 	tagify subscope

	###
	# Removes return statements
	###
	# def tagify(node, body = 'body')
	def VariableDeclaration(node)
		return node if node.declarations.length > 1
		let decl = node.declarations[0]
		console.log "nod", node
		return node unless decl.init..type == 'ArrowFunctionExpression'
		
		let func = decl.init
		let returns = getReturnStatements(func)
		
		return node unless returns.find(do $1.argument.type == 'JSXElement')
		func.type = 'FunctionDeclaration'
		func.id = decl.id
		this.FunctionDeclaration func
	# def VariableDeclarator(node)
	# 	return node unless node.init.type == 'ArrowFunctionExpression'
		
	# 	let func = node.init
	# 	let returns = getReturnStatements(func)
		
	# 	return node unless returns.find(do $1.argument.type == 'JSXElement')
	# 	func.type = 'FunctionDeclaration'
	# 	func.id = node.id
	# 	debugger
	# 	this.FunctionDeclaration func
		
	# def ArrowFunctionExpression(node)
	# 	this.FunctionDeclaration(node)
	def FunctionDeclaration(node)
		let returns = getReturnStatements(node)
		return node unless returns.find(do $1.argument.type == 'JSXElement' or $1.argument.type == 'JSXFragment')
		# Prevent implicit returns by adding an extra `return`
		const name = node.id.name
		const return-statement = node.body.body.find do $1.type == 'ReturnStatement' 

		const tree = return-statement.argument
		console.log "tree", tree
		
		return-statement.argument = {
			...tree
			type: "JSXElement"
			children: [tree]
			openingElement:{	
				...tree.openingElement
				type: "JSXOpeningElement"
				name:
					type: "JSXIdentifier"
					name: "self"
				attributes: []
			}
		}
		console.log "tree", return-statement.argument
		node = 
			type: "ClassDeclaration"
			kind: "tag"
			id:
				type: "Identifier"
				name: name
			body:
				type: "ClassBody"
				body: [{
					type: "MethodDefinition"
					value:
						params: []
						body: node.body
					body: node.body
					key:
						type: "Identifier"
						name: "render"
				}]
		node