import {build} from "../../index"
import * as imbac from 'imba/compiler'
let tsx-code1 = '''
export default function Example() {
  return <div className="transform -translate-x-3 translate-y-1 rotate-45"/>
}
'''
let imba-code1 = '''
export default tag Example
	def render
		<self>
			<div[x:-3 y:1 rotate:45deg]>

'''

test 'tailwind css code 1' do
	const result = await build tsx-code1
	expect(result.code).toEqual(imba-code1)
	const out = imbac.compile(result.code, sourceId: 'sth')

let tsx-code = '''
/* This example requires Tailwind CSS v2.0+ */
export default function Example() {
  return (
    <section className="bg-indigo-800">
      <div className="max-w-7xl mx-auto md:grid md:grid-cols-2 md:px-6 lg:px-8">
        <div className="py-12 px-4 sm:px-6 md:flex md:flex-col md:py-16 md:pl-0 md:pr-10 md:border-r md:border-indigo-900 lg:pr-16">
          <div className="md:flex-shrink-0">
            <img className="h-12" src="https://tailwindui.com/img/logos/tuple-logo-indigo-300.svg" alt="Tuple" />
          </div>
          <blockquote className="mt-6 md:flex-grow md:flex md:flex-col">
            <div className="relative text-lg font-medium text-white md:flex-grow">
              <svg
                className="absolute top-0 left-0 transform -translate-x-3 -translate-y-2 h-8 w-8 text-indigo-600"
                fill="currentColor"
                viewBox="0 0 32 32"
                aria-hidden="true"
              >
                <path d="M9.352 4C4.456 7.456 1 13.12 1 19.36c0 5.088 3.072 8.064 6.624 8.064 3.36 0 5.856-2.688 5.856-5.856 0-3.168-2.208-5.472-5.088-5.472-.576 0-1.344.096-1.536.192.48-3.264 3.552-7.104 6.624-9.024L9.352 4zm16.512 0c-4.8 3.456-8.256 9.12-8.256 15.36 0 5.088 3.072 8.064 6.624 8.064 3.264 0 5.856-2.688 5.856-5.856 0-3.168-2.304-5.472-5.184-5.472-.576 0-1.248.096-1.44.192.48-3.264 3.456-7.104 6.528-9.024L25.864 4z" />
              </svg>
              <p className="relative">
                lorem
				ipsum
              </p>
            </div>
            <footer className="mt-8">
              <div className="flex items-start">
                <div className="flex-shrink-0 inline-flex rounded-full border-2 border-white">
                  <img
                    className="h-12 w-12 rounded-full"
                    src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                    alt=""
                  />
                </div>
                <div className="ml-4">
                  <div className="text-base font-medium text-white">Judith Black</div>
                  <div className="text-base font-medium text-indigo-200">CEO, Tuple</div>
                </div>
              </div>
            </footer>
          </blockquote>
        </div>
        <div className="py-12 px-4 border-t-2 border-indigo-900 sm:px-6 md:py-16 md:pr-0 md:pl-10 md:border-t-0 md:border-l lg:pl-16">
          <div className="md:flex-shrink-0">
            <img
              className="h-12"
              src="https://tailwindui.com/img/logos/workcation-logo-indigo-300.svg"
              alt="Workcation"
            />
          </div>
          <blockquote className="mt-6 md:flex-grow md:flex md:flex-col">
            <div className="relative text-lg font-medium text-white md:flex-grow">
              <svg
                className="absolute top-0 left-0 transform -translate-x-3 -translate-y-2 h-8 w-8 text-indigo-600"
                fill="currentColor"
                viewBox="0 0 32 32"
              >
                <path d="M9.352 4C4.456 7.456 1 13.12 1 19.36c0 5.088 3.072 8.064 6.624 8.064 3.36 0 5.856-2.688 5.856-5.856 0-3.168-2.208-5.472-5.088-5.472-.576 0-1.344.096-1.536.192.48-3.264 3.552-7.104 6.624-9.024L9.352 4zm16.512 0c-4.8 3.456-8.256 9.12-8.256 15.36 0 5.088 3.072 8.064 6.624 8.064 3.264 0 5.856-2.688 5.856-5.856 0-3.168-2.304-5.472-5.184-5.472-.576 0-1.248.096-1.44.192.48-3.264 3.456-7.104 6.528-9.024L25.864 4z" />
              </svg>
              <p className="relative">
                lorem
				ipsum
				dora
              </p>
            </div>
            <footer className="mt-8">
              <div className="flex items-start">
                <div className="flex-shrink-0 inline-flex rounded-full border-2 border-white">
                  <img
                    className="h-12 w-12 rounded-full"
                    src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                    alt=""
                  />
                </div>
                <div className="ml-4">
                  <div className="text-base font-medium text-white">Joseph Rodriguez</div>
                  <div className="text-base font-medium text-indigo-200">CEO, Workcation</div>
                </div>
              </div>
            </footer>
          </blockquote>
        </div>
      </div>
    </section>
  )
}

'''

let imba-code = '''
export default tag Example
	def render
		<self>
			<section[bgc:indigo8]>
				<div[max-width:80rem mx:auto d@md:grid gtc@md:repeat(2,minmax(0,1fr)) px@md:1.5rem px@lg:2rem]>
					<div[py:3rem px:1rem px@sm:1.5rem d@md:flex fld@md:column py@md:4rem pl@md:0 pr@md:2.5rem bwr@md:1px bc@md:indigo9 pr@lg:4rem]>
						<div[fls@md:0]>
							<img[h:3rem] src="https://tailwindui.com/img/logos/tuple-logo-indigo-300.svg" alt="Tuple">
						<blockquote[mt:1.5rem flg@md:1 d@md:flex fld@md:column]>
							<div[pos:relative fs:lg lh:1.75rem fw:500 c:white flg@md:1]>
								<svg[pos:absolute t:0 l:0 x:-3 y:-2 h:2rem w:2rem c:indigo6] fill="currentColor" viewBox="0 0 32 32" aria-hidden="true">
									<path d="M9.352 4C4.456 7.456 1 13.12 1 19.36c0 5.088 3.072 8.064 6.624 8.064 3.36 0 5.856-2.688 5.856-5.856 0-3.168-2.208-5.472-5.088-5.472-.576 0-1.344.096-1.536.192.48-3.264 3.552-7.104 6.624-9.024L9.352 4zm16.512 0c-4.8 3.456-8.256 9.12-8.256 15.36 0 5.088 3.072 8.064 6.624 8.064 3.264 0 5.856-2.688 5.856-5.856 0-3.168-2.304-5.472-5.184-5.472-.576 0-1.248.096-1.44.192.48-3.264 3.456-7.104 6.528-9.024L25.864 4z">
								<p[pos:relative]>
									"lorem ipsum"
							<footer[mt:2rem]>
								<div[d:flex ai:flex-start]>
									<div[fls:0 d:inline-flex rd:full bw:2px bc:white]>
										<img[h:3rem w:3rem rd:full] src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
									<div[ml:1rem]>
										<div[fs:1rem lh:1.5rem fw:500 c:white]>
											"Judith Black"
										<div[fs:1rem lh:1.5rem fw:500 c:indigo2]>
											"CEO, Tuple"
					<div[py:3rem px:1rem bwt:2px bc:indigo9 px@sm:1.5rem py@md:4rem pr@md:0 pl@md:2.5rem bwt@md:0 bwl@md:1px pl@lg:4rem]>
						<div[fls@md:0]>
							<img[h:3rem] src="https://tailwindui.com/img/logos/workcation-logo-indigo-300.svg" alt="Workcation">
						<blockquote[mt:1.5rem flg@md:1 d@md:flex fld@md:column]>
							<div[pos:relative fs:lg lh:1.75rem fw:500 c:white flg@md:1]>
								<svg[pos:absolute t:0 l:0 x:-3 y:-2 h:2rem w:2rem c:indigo6] fill="currentColor" viewBox="0 0 32 32">
									<path d="M9.352 4C4.456 7.456 1 13.12 1 19.36c0 5.088 3.072 8.064 6.624 8.064 3.36 0 5.856-2.688 5.856-5.856 0-3.168-2.208-5.472-5.088-5.472-.576 0-1.344.096-1.536.192.48-3.264 3.552-7.104 6.624-9.024L9.352 4zm16.512 0c-4.8 3.456-8.256 9.12-8.256 15.36 0 5.088 3.072 8.064 6.624 8.064 3.264 0 5.856-2.688 5.856-5.856 0-3.168-2.304-5.472-5.184-5.472-.576 0-1.248.096-1.44.192.48-3.264 3.456-7.104 6.528-9.024L25.864 4z">
								<p[pos:relative]>
									"lorem ipsum dora"
							<footer[mt:2rem]>
								<div[d:flex ai:flex-start]>
									<div[fls:0 d:inline-flex rd:full bw:2px bc:white]>
										<img[h:3rem w:3rem rd:full] src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
									<div[ml:1rem]>
										<div[fs:1rem lh:1.5rem fw:500 c:white]>
											"Joseph Rodriguez"
										<div[fs:1rem lh:1.5rem fw:500 c:indigo2]>
											"CEO, Workcation"

'''
test 'tailwind css code' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')