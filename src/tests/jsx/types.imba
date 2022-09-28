import {build} from "../../index"
import * as imbac from 'imba/compiler'
###
// const subtitle: React.CSSProperties = {
// 	fontFamily: FONT_FAMILY,
// 	fontSize: 40,
// 	textAlign: 'center',
// 	position: 'absolute',
// 	bottom: 140,
// 	width: '100%',
// };

// const codeStyle: React.CSSProperties = {
// 	color: COLOR_1,
// };

###
let tsx-code1 = '''
import React from 'react';
import {interpolate, useCurrentFrame} from 'remotion';
import {COLOR_1, FONT_FAMILY} from './constants';

const subtitle: React.CSSProperties = {
	fontFamily: FONT_FAMILY,
	fontSize: 40,
	textAlign: 'center',
	position: 'absolute',
	bottom: 140,
	width: '100%',
};

const codeStyle: React.CSSProperties = {
	color: COLOR_1,
};

export const Subtitle: React.FC = () => {
	const frame = useCurrentFrame();
	const opacity = interpolate(frame, [0, 30], [0, 1]);
	return (
		<div style={{...subtitle, opacity}}>
			Edit <code style={codeStyle}>src/Video.tsx</code> and save to reload.
		</div>
	);
};

'''

test 'strip types + export named declarations 123' do
	const result = await build tsx-code1
	expect(result.code).toMatchSnapshot!
	const out = imbac.compile(result.code, sourceId: 'sth')
