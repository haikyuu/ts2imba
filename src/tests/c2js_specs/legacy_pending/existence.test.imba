import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function ifChecks() {
    if (x) { yep }
    if (!x) { yep }
}
function ifNullChecks() {
    if (x==null) { yep }
    if (x===null) { nah }
    if (obj.x==null) {yep}
}
function voidChecks() {
    if (x==void 0) { yep }
    if (x===void 0) { nah }
    if (x==void 1) { yep }
}
function undefinedChecks() {
    if (typeof x == 'undefined') { nah }
    if (x == undefined) {yep}
    if (obj.x == undefined) { nah }
}
function edgeCase() {
    if (!x == y) { nah }
}

function unlessChecks() {
    if (x!=null) { yep }
    if (x!==null) { nah }
    if (typeof x != 'undefined') { wat }
    if (x != undefined) { nah }
    if (obj.x != undefined) { wat }
}

function whileAndFor() {
    while (x==null) { yep }
    while (x===null) { yep }

    for (a;x==null;2) { yep }
}
'''

let imba-code = '''
ifChecks = ->
  yep  if x
  yep  unless x
  return
ifNullChecks = ->
  yep  unless x?
  nah  if x is null
  yep  unless obj.x?
  return
voidChecks = ->
  yep  unless x?
  nah  if x is undefined
  yep  unless x?
  return
undefinedChecks = ->
  nah  if typeof x is "undefined"
  yep  unless x?
  nah  unless obj.x?
  return
edgeCase = ->
  nah  if not x is y
  return
unlessChecks = ->
  yep  if x?
  nah  if x isnt null
  wat  unless typeof x is "undefined"
  nah  if x?
  wat  if obj.x?
  return
whileAndFor = ->
  yep  until x?
  yep  while x is null
  a
  while not x?
    yep
    2
  return
'''
test 'existence' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js