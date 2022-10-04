import map-style from './utils/map-style'
import { aliases } from './utils/styler'
import postcss from 'postcss'
import TransformerBase from './base'
import cssesc from "cssesc";
###
# Does transformations pertaining to `return` statements.
###

export default class TailwindTransformer < TransformerBase
	_css = {}

	def onScopeEnter(scope, ctx, subscope, subctx)
		_css = postcss.parse options.parsedCSS

	def find-rule(cls)
		let results = []
		const escaped-class = cssesc cls, {isIdentifier: yes}
		const double-escaped-class = cssesc escaped-class, {isIdentifier: yes}
		def handle-rule(rule, media = null)
			for sel in rule.selectors
				let modifiers = []
				const r-sel = sel.replace(/[\\\.]/g, '')
				if r-sel === cls or "{cls}:focus" == r-sel or "{cls}:hover" == r-sel
					modifiers.push 'focus' if sel.endsWith ':focus'
					modifiers.push 'hover' if sel.endsWith ':hover'
					results.push {rule, modifiers, media}
			return

		for rule in _css.nodes when rule.type != 'comment'
			if rule.type == "atrule"
				for node in rule.nodes
					results.push handle-rule(node, rule)
			else
				results.push handle-rule(rule)
		results.filter do $1
			
	def get-is(classes\string[], f)
		let overriden-find-rule = f or find-rule
		let inline-styles = []
		let unhandled-classes = []
		let css-vars = []
		let media-queries = []
		# global variables
		# console.log classes
		for rule in  _css.nodes when rule.type != 'comment' and rule.selectors..indexOf('*') > -1
			for decl in rule.nodes when decl.variable
				decl.__global = yes
				css-vars.push decl
		# variable declaration rules
		for cls in classes
			const results = overriden-find-rule.bind(this)(cls)
			for r in results
				const {rule} = r
				for decl in rule.nodes
					if decl.prop.startsWith '--'
						css-vars.push decl
		
		for cls in classes
			const results = overriden-find-rule.bind(this)(cls)
			unhandled-classes.push cls if results.length == 0
			for r in results
				let {rule, media, modifiers} = r
				let mod = ""
				if media
					let breakpoints =
						"480": "xs" 
						"640": "sm" 
						"768": "md" 
						"1024": "lg" 
						"1280px": "xl" 
					const number = media.params.replace(/\D/g,'') 
					if media.params.includes('max-width')
						mod += "@!{number}"
					elif media.params.includes('min-width')
						const native-mod = breakpoints[number]
						mod += "@{native-mod or number}"
					else
						console.warn "Unkown modifier {media.params}"
				mod += "@{modifiers.join('@')}" if modifiers.length

				const styles = map-style(rule.nodes, cls,css-vars, mod)
				inline-styles = inline-styles.concat styles
		const styles = inline-styles.reduce(&, []) do(acc, s)
			acc.push(s) unless acc.indexOf(s) > -1
			acc

		{unhandled-classes, inline-styles: styles}

	def JSXAttribute(node)
		if node.name.name == 'className'
			const classes = node.value.value..split(" ")
			node.imba = get-is classes if classes
			
			# const declarations = v
			# 	.split(" ")
			# 	.map(do(cls) _css.nodes.find do({selector}) selector == ".{cls}")
			# 	.filter(do $1)
			# 	.reduce(&, []) do(acc, rule) 
			# 		
			# 		acc.concat rule.nodes
			# 

			# node.inlineStyles = map-style(declarations, v, "")
			# let at-declarations = []
			# for at-rule in _css.nodes when at-rule.type == 'atrule'
			# 	for decl in at-rule.nodes when decl.selector == ".{cls}"

			# const at-declarations = v
			# 	.split(" ")
			# 	.map(do(cls) _css.nodes.filter(do $1.type == 'atrule').find do({selector}) selector == ".{cls}")
			# 	.filter(do $1)
			# 	.reduce(&, []) do(acc, rule) 
			# 		
			# 		acc.concat rule.nodes
			# const inline-styles = declarations.map do(decl)
			# 	decl.imba ||= {} 
			# 	
			# 	for own k,v of aliases
			# 		if v === decl.prop
			# 			decl.imba.prop = k
			# 			return decl
			# node.inlineStyles = inline-styles
				

		node