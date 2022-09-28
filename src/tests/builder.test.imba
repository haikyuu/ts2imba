import Builder from '../index'

describe 'BuilderBase' do
	let ast = undefined
	let output = undefined

	beforeEach do
		ast =
			type: 'Program'
			body:
				type: 'Identifier'
				value: 'hi'

		class MyWalker < Builder
			def constructor
				super

			def Program(node)
				walk node.body
			def Identifier(node)
				node.value

		output = new MyWalker(ast).run()
		# the return value from beforeEach is supposed to be a fn. or undefined
		undefined

	test 'works' do
		expect(output.toString()).toEqual 'hi'

	test 'spits out a SourceNode' do
		expect(output.children).toBeInstanceOf Array
