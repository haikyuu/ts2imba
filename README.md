## TS 2 Imba
alpha software that works well enough

- Doesn't support template literals atm. (and probably many other things) 😄 

It also converts react function components to imba tags and tailwind classes into imba inline styles

# Current limitations
- Should work in the browser ... but it doesn't for some reason (didn't spend much time trying to fix it since I was the only user)
- Template literals have a weird AST representation. I'd rather just do some regex magic to remove unescaped $ and use "" or  """ instead. For now, I change ` to " manually in the js code ^^
- The majority of js2coffee tests aren't ported yet. 

# Contribute
Contributions are very welcome, the easiest way to contribute is to 
1. add a failing test case in an issue
2. If you face `"ASTType" is not supported`, create a `def ASTType(node, ctx) do debugger` in `builder.imba` and see if you can make it work. Start with returning an array with a random string, then create a failing test case, focus on it with `test.only` and run vitest on the file `npx vitest my_file.test.imba` (you need to have `npm run build:watch` to be able to run tests)
# Credits
- This wouldn't have been possible without the amazing work of https://github.com/rstacruz on https://github.com/js2coffee/js2coffee