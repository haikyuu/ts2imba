# import {build} from "../../index"
# import * as imbac from 'imba/compiler'

# let tsx-code2 = '''
# function App(){
# 	const open = true
# 	return (
# 		<Dialog.panel>hi</Dialog.panel>
# 	)
# }
# '''

# let imba-code2 = '''
# tag App
# 	def render
# 		const open = true
# 		<self>
# 			<dialog-panel>
# 				"hi"

# '''
test 'Support dialog.panel style in tags' do 1
# 	const result = await build tsx-code2
# 	expect(result.code).toEqual(imba-code2)
# 	const out = imbac.compile(result.code, sourceId: 'sth')
# let tsx-code3 = '''
# import { Dialog, Transition } from '@headlessui/react'
# import { Fragment, useState } from 'react'

# export default function MyModal() {
#   let [isOpen, setIsOpen] = useState(true)

#   function closeModal() {
#     setIsOpen(false)
#   }

#   function openModal() {
#     setIsOpen(true)
#   }

#   return (
#     <>
#       <div className="fixed inset-0 flex items-center justify-center">
#         <button
#           type="button"
#           onClick={openModal}
#           className="rounded-md bg-black bg-opacity-20 px-4 py-2 text-sm font-medium text-white hover:bg-opacity-30 focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75"
#         >
#           Open dialog
#         </button>
#       </div>

#       <Transition appear show={isOpen} as={Fragment}>
#         <Dialog as="div" className="relative z-10" onClose={closeModal}>
#           <Transition.Child
#             as={Fragment}
#             enter="ease-out duration-300"
#             enterFrom="opacity-0"
#             enterTo="opacity-100"
#             leave="ease-in duration-200"
#             leaveFrom="opacity-100"
#             leaveTo="opacity-0"
#           >
#             <div className="fixed inset-0 bg-black bg-opacity-25" />
#           </Transition.Child>

#           <div className="fixed inset-0 overflow-y-auto">
#             <div className="flex min-h-full items-center justify-center p-4 text-center">
#               <Transition.Child
#                 as={Fragment}
#                 enter="ease-out duration-300"
#                 enterFrom="opacity-0 scale-95"
#                 enterTo="opacity-100 scale-100"
#                 leave="ease-in duration-200"
#                 leaveFrom="opacity-100 scale-100"
#                 leaveTo="opacity-0 scale-95"
#               >
#                 <Dialog.Panel className="w-full max-w-md transform overflow-hidden rounded-2xl bg-white p-6 text-left align-middle shadow-xl transition-all">
#                   <Dialog.Title
#                     as="h3"
#                     className="text-lg font-medium leading-6 text-gray-900"
#                   >
#                     Payment successful
#                   </Dialog.Title>
#                   <div className="mt-2">
#                     <p className="text-sm text-gray-500">
#                       Your payment has been successfully submitted. We\'ve sent
#                       you an email with all of the details of your order.
#                     </p>
#                   </div>

#                   <div className="mt-4">
#                     <button
#                       type="button"
#                       className="inline-flex justify-center rounded-md border border-transparent bg-blue-100 px-4 py-2 text-sm font-medium text-blue-900 hover:bg-blue-200 focus:outline-none focus-visible:ring-2 focus-visible:ring-blue-500 focus-visible:ring-offset-2"
#                       onClick={closeModal}
#                     >
#                       Got it, thanks!
#                     </button>
#                   </div>
#                 </Dialog.Panel>
#               </Transition.Child>
#             </div>
#           </div>
#         </Dialog>
#       </Transition>
#     </>
#   )
# }
# '''

# let imba-code3 = '''
# import Dialog,Transition,from '@headlessui/react'
# import Fragment,useState,from 'react'
# export default def MyModal
# 	let [isOpen, setIsOpen] = useState(true)
# 	def closeModal
# 		setIsOpen false
# 	def openModal
# 		setIsOpen true
# 	return <>
# 		<div[pos:fixed b:0 l:0 r:0 t:0 d:flex ai:center jc:center]>
# 			<button type="button" onClick=openModal[rd:md bgc:black px:1rem py:.5rem fs:sm lh:1.25rem fw:500 c:white outline@focus:2px solid transparent outline-offset@focus:2px]>
# 				"Open dialog"
# 		<Transition appear show=isOpen as=Fragment>
# 			<Dialog as="div"[pos:relative zi:10] onClose=closeModal>
# 				<transition-Child as=Fragment enter="ease-out duration-300" enterFrom="opacity-0" enterTo="opacity-100" leave="ease-in duration-200" leaveFrom="opacity-100" leaveTo="opacity-0">
# 					<div[pos:fixed b:0 l:0 r:0 t:0 bgc:black]>
# 				<div[pos:fixed b:0 l:0 r:0 t:0 ofy:auto]>
# 					<div[d:flex min-height:100% ai:center jc:center p:1rem ta:center]>
# 						<transition-Child as=Fragment enter="ease-out duration-300" enterFrom="opacity-0 scale-95" enterTo="opacity-100 scale-100" leave="ease-in duration-200" leaveFrom="opacity-100 scale-100" leaveTo="opacity-0 scale-95">
# 							<dialog-Panel[w:100% max-width:28rem  of:hidden rd:1rem bgc:white p:1.5rem ta:left va:middle bxs:xl transition-duration:.15s transition-property:all transition-timing-function:cubic-bezier(.4,0,.2,1)]>
# 								<dialog-Title as="h3"[fs:lg lh:1.75rem fw:500 lh:1.5rem c:gray9]>
# 									"Payment successful"
# 								<div[mt:.5rem]>
# 									<p[fs:sm lh:1.25rem c:gray5]>
# 										"Your payment has been successfully submitted. We\\'ve sent you an email with all of the details of your order."
# 								<div[mt:1rem]>
# 									<button type="button"[d:inline-flex jc:center rd:md bw:1px bc:transparent bgc:blue1 px:1rem py:.5rem fs:sm lh:1.25rem fw:500 c:blue9 bgc@hover:blue2 outline@focus:2px solid transparent outline-offset@focus:2px] onClick=closeModal>
# 										"Got it, thanks!"

# '''
# test.only 'Support dialog.panel style in tags' do
# 	const result = await build tsx-code3
# 	console.log result.code
# 	expect(result.code).toEqual(imba-code3)
# 	const out = imbac.compile(result.code, sourceId: 'sth')
