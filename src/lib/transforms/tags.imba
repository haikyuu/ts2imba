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
		return node unless decl.init..type == 'ArrowFunctionExpression'
		
		let func = decl.init
		let returns = getReturnStatements(func)
		if returns.find(do $1.argument.type == 'JSXElement')
			func.type = 'FunctionDeclaration'
			func.id = decl.id
			this.FunctionDeclaration func
		else node 
	# def VariableDeclarator(node)
	# 	return node unless node.init.type == 'ArrowFunctionExpression'
		
	# 	let func = node.init
	# 	let returns = getReturnStatements(func)
		
	# 	return node unless returns.find(do $1.argument.type == 'JSXElement')
	# 	func.type = 'FunctionDeclaration'
	# 	func.id = node.id
	# 	debugger
	# 	this.FunctionDeclaration func
	def ClassDeclaration(node, ctx)
		# transform classic react class syntax to tags
		if node..body..body..find(do $1.key.name == "render")
			node.kind = "tag"
			const expression = node..body..body..[0]..value..body..body..[0]
			if expression
				expression.argument = {
					...expression.argument,
					type: "JSXElement"
					children: [expression.argument]
					openingElement:{	
						...expression.argument.openingElement
						type: "JSXOpeningElement"
						name:
							type: "JSXIdentifier"
							name: "self"
						attributes: []
					}
				}
			if node.body.body.length == 1 and node.body.body[0].value.body.body.length == 1
				node.body.body = [{
					type: "RenderMethodInline"
					body: expression.argument
				}] 
			# node = 
			# 	type: "ClassDeclaration"
			# 	kind: "tag"
			# 	id:
			# 		type: "Identifier"
			# 		name: name
			# 	body:
			# 		type: "ClassBody"
			# 		body: body
		node
	def ArrowFunctionExpression(node)
		node.id = name: "my-tag" unless node.id
		this.FunctionDeclaration(node)
	def FunctionDeclaration(node)
		let returns = getReturnStatements(node)
		return node unless returns.find(do $1.argument and ($1.argument.type == 'JSXElement' or $1.argument.type == 'JSXFragment'))
		# Prevent implicit returns by adding an extra `return`
		const name = node.id.name
		const return-statement = node.body.body.find do $1.type == 'ReturnStatement' 

		const tree = return-statement.argument
		
		# Skip transformation if return statement has no argument (empty return)
		return node unless tree
		
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
		let body = [{
			type: "MethodDefinition"
			value:
				params: []
				body: node.body
			body: node.body
			key:
				type: "Identifier"
				name: "render"
		}]
		if node.body.body.length == 1 and node.body.body[0].type == "ReturnStatement"
			body = [{
				type: "RenderMethodInline"
				body: node.body.body[0].argument
			}] 
		node = 
			type: "ClassDeclaration"
			kind: "tag"
			id:
				type: "Identifier"
				name: name
			body:
				type: "ClassBody"
				body: body
		node
