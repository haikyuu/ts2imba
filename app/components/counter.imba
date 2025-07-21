import {screen, waitFor} from "@testing-library/dom"

export default tag Counter < button
	prop count = 0
	<self @click=count++> `Count is {count}`
