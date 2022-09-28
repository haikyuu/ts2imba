import { variants } from './theme'
import {aliases } from './styler'

export default def map-style(declarations, cls, css-vars, mod\string)
	let styles = []

	for declaration in declarations when !declaration.prop.startsWith '--'
		let {prop: _prop, value} = declaration
		if declaration.prop === 'color' or declaration.value.includes('rgb(')
			const parts = cls.split('-')
			if parts.length === 3
				const num-part = parts[2].match(/(\d+)/)
				if num-part and num-part[1] == '50'
					value = parts[1] + "1"
				else
					value = parts[1] + parts[2][0]

			else
				value = parts[1]
			
			for v in css-vars
				if declaration.value.includes "/ var({v.prop}" and v.value != "1"
					value = "{value}/{v.value}"


		for own k,v of aliases
			if v === _prop
				_prop = k
		# todo: handle colors, css variables, opacity
		# if value.endsWith "rem"
		# 	value = value.replace /rem$/g, ''
		const props = [
			['bxs', 'box-shadow', 'shadow']
			['rd', 'radius', 'rounded']
			['fs', 'font-size', 'text']
			# ['e', 'easings', ]
		]
		for p in props
			if _prop == p[0]
				let size = cls.replace("{p[2]}-", '')
				if variants[p[1]][size]
					value = size
				elif cls == 'shadow'
					value = 'sm'

		styles.push {prop: _prop, value}
	for style in styles
		for own k,v of aliases 
			if Array.isArray v
				let i = v.indexOf(style.prop)
				if i > -1
					let others = []
					for other in v
						const st = styles.find do(s) s.prop == other and style.value == s.value
						if st
							others.push st
					if v.length == others.length
						const grouped = {prop: k, value: style.value}
						styles = styles.filter do(ss)
							!others.find do(other)
								other.prop == ss.prop and other.value == ss.value
						styles.push grouped
	styles.map do(style)
		const matches = style.value..matchAll /var\(--(.*?)\)/g
		for m of matches
			for decl in css-vars when !decl.__global
				let with-fallback = m[1].matchAll /([^,]*),([^,]*)/g
				with-fallback = [...with-fallback]
				if with-fallback.length
					if style.value.includes m[0]
						style.value = style.value.replaceAll(m[0], decl.value or with-fallback[2].trim())
				if decl.prop.replace('--', '') == m[1] and style.value.includes decl.prop
					style.value = style.value.replaceAll m[0], decl.value
			
			style.value = style.value.replace m[0], ""
		if style.prop == 'transform'
			style.value = style.value..replaceAll(/[a-zA-Z]*\(\)\s?/g, "")
			const fm = style.value..matchAll /([a-zA-Z]*)\(([^,)]*)((,)([^,)]*))?((,)([^,)]*))?\)/g
			# handle translate and rotate
			# use https://regex101.com/r/QW5wdK/1
			let s = ""
			for f of fm
				const fn = f[1]
				const x = f[2]
				const y = f[5]
				const z = f[8]
				let _ref = ["x", "y", "z"]
				if fn == "translate"
					for v, i in [x, y, z]
						if v..indexOf('rem') > -1
							v = + v.replace('rem', '')
							v /= 0.25
							s += "{_ref[i]}:{v} "
				elif fn == "rotate" and x
					s += "rotate:{x}"
			return s.trim()
		"{style.prop}{mod}:{style.value}"