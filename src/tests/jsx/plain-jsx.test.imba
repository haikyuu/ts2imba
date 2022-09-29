import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function App(){
	return (
		<div>
			<span>Test</span>
		</div>
	)
}
'''
test 'spaces_4' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')

const tsx-code2 = '''
import React, { useState } from 'react';

export default () => {
    const [a, setA] = useState(1);
    const [b, setB] = useState(2);

    function handleChangeA(event) {
        setA(+event.target.value);
    }

    function handleChangeB(event) {
        setB(+event.target.value);
    }

    return (
        <div>
            <input type="number" value={a} onChange={handleChangeA} />
            <input type="number" value={b} onChange={handleChangeB} />

            <p>
                {a} + {b} = {a + b}
            </p>
        </div>
    );
};
'''
test 'anonymous function component' do
	const result = await build tsx-code2
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')

const tsx-code3 = '''
function usePrevious(value) {

  useEffect(() => {
    ref.current = value
  }, [value])

  return ref.current
}

export default function App() {
  return (
    <>
    </>
  )
}
'''
test 'component 112' do
	const result = await build tsx-code3
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
