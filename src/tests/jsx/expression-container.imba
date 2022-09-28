# import {build} from "../../index"
# import * as imbac from 'imba/compiler'

# let tsx-code2 = '''

# export default function Example() {
#   return (
#     <div>
#       <Disclosure as="div" className="relative bg-sky-700 pb-32 overflow-hidden">
#         {({ open }) => (
#           <>
#             <nav
#               className={classNames(
#                 open ? 'bg-sky-900' : 'bg-transparent',
#                 'relative z-10 border-b border-teal-500 border-opacity-25 lg:bg-transparent lg:border-none'
#               )}
#             ></nav></>)}</Disclosure></div>)}

# '''

# let imba-code2 = '''
# tag App
# 	def render
# 		<self>
# 			<div>
# 				<disclosure[] children=(do({open})
# 					<>
# 						<nav[] []=open>	
# 				)>

# '''
test 'compiles render prop correctly' do
	1
	# const result = await build tsx-code2
	# console.log result.code
	# expect(result.code).toEqual(imba-code2)
	# const out = imbac.compile(result.code, sourceId: 'sth')
