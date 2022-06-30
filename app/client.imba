global css html,body w:100% h:100% m:0 p:0
tag App
	@observable tsx = ""
	imba-code = ""
	timer
	@autorun
	def compile
		return unless tsx
		clearTimeout timer if timer
		timer = setTimeout(&, 600) do _compile!

	def _compile
		const body = JSON.stringify code: tsx
		const res = await global.fetch "/imba", {
			body:body, method:"POST", headers: {'Content-Type': 'application/json'},
		}
		imba-code = (await res.json!).code
		imba.commit!
	<self[p:6 bg:pink9]>
		<h1[c:white ff:mono td:overline]> "TSX 2 Imba"
		<div[d:hflex ai:center jc:space-around  h:100%]>
			css textarea fl:1 h:90vh bd:12px amber4 solid bg:cool8 c:amber4 ff:mono p:4 fs:xl
			<textarea[mr:6] bind=tsx @change=compile placeholder="Write ts, tsx or js code here \nP.S: tailwind classes are converted as well (in a component)">
			<textarea bind=imba-code readOnly placeholder="Imba code will appear here (hopefully ... I'm still @ alpha stage)">
imba.mount <App>