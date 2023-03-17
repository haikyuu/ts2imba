import {grammar} from './utils/grammar.imba' # imba/src/program/grammar.imba
import logo from './assets/imba.svg'
import github-logo from './assets/github-logo.svg'
import {build} from "../src"

const base = import.meta.env.PROD ? "https://api.ts2imba.com": ""
global css
	body,html,#app size:100% bg:bl
	@root
		fs:16px lh:24px fw:400 c:white/87
		color-scheme: light dark
		bgc:#242424

export const id = 'imba'
export const extensions = ['.imba']
export const aliases = ['Imba', 'imba']

let default-tsx-code = '''
export default function Example() {
  return (
    <>
      <div className="flex min-h-full items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
        <div className="w-full max-w-md space-y-8">
          <div>
            <img
              className="mx-auto h-12 w-auto"
              src="https://tailwindui.com/img/logos/mark.svg?color=indigo&shade=600"
              alt="Your Company"
            />
            <h2 className="mt-6 text-center text-3xl font-bold tracking-tight text-gray-900">
              Sign in to your account
            </h2>
            <p className="mt-2 text-center text-sm text-gray-600">
              Or{' '}
              <a href="#" className="font-medium text-indigo-600 hover:text-indigo-500">
                start your 14-day free trial
              </a>
            </p>
          </div>
          <form className="mt-8 space-y-6" action="#" method="POST">
            <input type="hidden" name="remember" defaultValue="true" />
            <div className="-space-y-px rounded-md shadow-sm">
              <div>
                <label htmlFor="email-address" className="sr-only">
                  Email address
                </label>
                <input
                  id="email-address"
                  name="email"
                  type="email"
                  autoComplete="email"
                  required
                  className="relative block w-full appearance-none rounded-none rounded-t-md border border-gray-300 px-3 py-2 text-gray-900 placeholder-gray-500 focus:z-10 focus:border-indigo-500 focus:outline-none focus:ring-indigo-500 sm:text-sm"
                  placeholder="Email address"
                />
              </div>
              <div>
                <label htmlFor="password" className="sr-only">
                  Password
                </label>
                <input
                  id="password"
                  name="password"
                  type="password"
                  autoComplete="current-password"
                  required
                  className="relative block w-full appearance-none rounded-none rounded-b-md border border-gray-300 px-3 py-2 text-gray-900 placeholder-gray-500 focus:z-10 focus:border-indigo-500 focus:outline-none focus:ring-indigo-500 sm:text-sm"
                  placeholder="Password"
                />
              </div>
            </div>

            <div className="flex items-center justify-between">
              <div className="flex items-center">
                <input
                  id="remember-me"
                  name="remember-me"
                  type="checkbox"
                  className="h-4 w-4 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500"
                />
                <label htmlFor="remember-me" className="ml-2 block text-sm text-gray-900">
                  Remember me
                </label>
              </div>

              <div className="text-sm">
                <a href="#" className="font-medium text-indigo-600 hover:text-indigo-500">
                  Forgot your password?
                </a>
              </div>
            </div>

            <div>
              <button
                type="submit"
                className="group relative flex w-full justify-center rounded-md border border-transparent bg-indigo-600 py-2 px-4 text-sm font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
              >
                <span className="absolute inset-y-0 left-0 flex items-center pl-3">
                </span>
                Sign in
              </button>
            </div>
          </form>
        </div>
      </div>
    </>
  )
}

'''

export const configuration = {
	wordPattern: /(-?\d*\.\d\w*)|([^\`\~\!\@\#%\^\&\*\(\)\=\$\-\+\[\{\]\}\\\|\;\:\'\"\,\.\<\>\/\?\s]+)/g,
	comments: {
		blockComment: ['###', '###'],
		lineComment: '#'
	},
	brackets: [
		['{', '}','delimiter.curly'],
		['[', ']','delimiter.square'],
		['(', ')','delimiter.parenthesis'],
		['<', '>','delimiter.angle']
	],
	autoClosingPairs: [
		{ open: '"', close: '"', notIn: ['string', 'comment'] },
		{ open: '\'', close: '\'', notIn: ['string', 'comment'] },
		{ open: '{', close: '}', notIn: ['comment'] },
		{ open: '[', close: ']', notIn: ['string', 'comment'] },
		{ open: '(', close: ')', notIn: ['string', 'comment'] },
		{ open: '<', close: '>', notIn: ['string','comment','operators'] },
	],
	onEnterRules: [{
		beforeText: /^\s*(?:def|get \w|set \w|class|for|if|elif|else|while|try|with|finally|except|async).*?$/,
		action: { indentAction: 1 }
	},{
		beforeText: /\s*(?:do)\s*(\|.*\|\s*)?$/,
		action: { indentAction: 1 }
	}]
}


export default tag App
	monaco
	imba-editor
	ts-editor
	get imba-code do imba-editor..getValue!
	get ts-code do ts-editor..getValue!
	def new-chart(id, data)
		console.log "::new chart"
		const {Chart} = await import("@antv/g2")
		document.getElementById(id).innerHTML = ""
		const chart = new Chart
			container: id
			height: 130
			width: 230
			legend: no
			autoFit: yes
			padding: [20,0,50,100]
		chart.data data
		chart.coordinate().transpose().scale 1, -1
		chart.axis "value", position: "right"
		chart.axis "label", label:
			offset: 12
		chart.tooltip
			shared: true
			showMarkers: false
		chart.interval().position("type*value").color("label", ['#76aafe', '#ffc403']).adjust [{
			type: "dodge"
			marginRatio: 0
		}]
		chart.interaction "active-region"

		chart.render()
		chart
	def render-chart
		new-chart "container1", [
			{ label: "JavaScript", value: ts-code.split(/\r\n|\r|\n/).length, type: "Lines of code" }
			{ label: "Imba", value: imba-code.split(/\r\n|\r|\n/).length, type: "Lines of code" }
		]
		new-chart "container2", [
			{ label: "JavaScript", value: ts-code.length, type: "# of characters" }
			{ label: "Imba", value: imba-code.length, type: "# of characters" }
		]

	def create-editor(el, lang)
		el.innerHTML = null
		monaco.editor.setTheme "imba-dark"
		let codeModel
		if lang == "typescript"
			const modelUri = monaco.Uri.file("foo.tsx")
			codeModel = monaco.editor.createModel default-tsx-code, "typescript", modelUri
			monaco.languages.typescript.typescriptDefaults.setCompilerOptions jsx: "react"
			monaco.languages.typescript.typescriptDefaults.setDiagnosticsOptions
				noSemanticValidation: false
				noSyntaxValidation: false
			
		const editor = monaco.editor.create el,
			value: lang == "typescript" ? default-tsx-code: ""
			language: lang
			minimap: {enabled: no}
			modelUri: (lang == "typescript" ? monaco.Uri.file("foo.tsx") : unedfined)
		editor.addAction
			id: "my-unique-id"
			label: "My Label!!!"
			keybindings: [monaco.KeyMod.CtrlCmd | monaco.KeyCode.KeyS]
			precondition: null
			keybindingContext: null
			contextMenuGroupId: "navigation"
			contextMenuOrder: 1.5
			run: do convert!
		editor.setModel codeModel if codeModel
		editor
	def setup-monaco
		monaco ||=  await import('monaco-editor')
		const {theme} = await import("./utils/scrimba-dark.theme.imba")
		monaco.editor.defineTheme "imba-dark", theme.toMonaco!
		global.self.MonacoEnvironment = getWorker: do(_, label)
			if label === "json"
				const jsonWorker = await import("monaco-editor/esm/vs/language/json/json.worker?worker")
				return new jsonWorker
			if label === "css" or label === "scss" or label === "less"
				const cssWorker = await import("monaco-editor/esm/vs/language/css/css.worker?worker")
				return new cssWorker
			if label === "html" or label === "handlebars" or label === "razor"
				const htmlWorker = await import("monaco-editor/esm/vs/language/html/html.worker?worker")
				return new htmlWorker
			if label === "typescript" or label === "javascript"
				const tsWorker = await import("monaco-editor/esm/vs/language/typescript/ts.worker?worker")
				return new tsWorker
			const editorWorker = await import("monaco-editor/esm/vs/editor/editor.worker?worker")
			new editorWorker
		monaco.languages.register({id,extensions,aliases})
		monaco.languages.onLanguage(id) do
			monaco.languages.setMonarchTokensProvider(id, grammar)
			monaco.languages.setLanguageConfiguration(id, configuration)
	def mount
		# render-chart!
		await setup-monaco!
		ts-editor = create-editor $ts-editor, "typescript"
		imba-editor = create-editor $imba-editor, "imba"
		convert!
	def convert
		const body = JSON.stringify code: ts-code
		const code = await build(ts-code)
		# const res = await global.fetch "{base}/api/imba", {
		# 	body:body, method:"POST", headers: {'Content-Type': 'application/json'},
		# }
		# const code = (await res.json!).code
		imba-editor.setValue code.code
		render-chart!
	<self[size:100% py:4]>
		<global @hotkey("command+s")=convert>
		css .move 
			@keyframes move
				0% w:0 l:0 o:0
				30% w:100% l:0 o:1
				100% w:0 l:100% o:0
		<header[d:hflex ai:center h:80px w:100%]>
			<a href="https://imba.io" target="_blank"> <svg[size:48px filter:url(#red-glow)] src=logo>
			<div[pos:relative]>
				<span[fw:600 fs:2xl ff:mono c:amber3 ml:2]> "TS 2 Imba"
				for i in [1 .. 3]
					<div.move[pos:absolute b:{i} h:{2/3} rd:3 bg:red3/30 zi:-1 w:100% animation:move 4s infinite forwards animation-delay:{i*200}ms]>
			<span[fw:400 fs:lg ff:mono c:amber1 ml:5 mb:-1 fl:1]> "Transform js, ts or tsx and tailwind classes to imba"
			<button type="button" @click=convert [mx:4 cursor:pointer d:inline-flex ai:center rd:md bw:1px bc:transparent bgc:amber1 px:1rem py:.5rem fs:1rem lh:1.5rem fw:500 c:cool8 bxs:sm bgc@hover:amber2 outline@focus:2px solid transparent outline-offset@focus:2px bxs@focus:0 0 0 ,0 0 0 2px,1]>
				"Convert"
			<a[filter@hover:url(#red-glow)] href="https://github.com/haikyuu/ts2imba" target="_blank"> <svg[size:32px c:white stroke:amber3] src=github-logo>
			<footer[w:100 d:flex fld:row ai:center]>
				<#container1[w:100%]>
				<#container2[w:100%]>
		<main[d:flex fld:row size:100% jc:space-between]>
			<section$ts-editor[fl:1 mr:2]> "TSX code"
			<section$imba-editor[fl:1 ml:2]> "Imba Code"
		


imba.mount <App>, document..getElementById "app"
