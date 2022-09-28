import { build, defineConfig } from 'vite';
import { imba } from 'vite-plugin-imba';
import { resolve } from 'path'
import { builtinModules } from 'module'
import monacoEditorPlugin from "vite-plugin-monaco-editor"
import path from 'path'
// ENTRY
const entry = resolve(__dirname, "app/main.js")

export default defineConfig(({ command, mode }) => {
	return {
		server: {
			host: true,
			proxy: {
				'/api': {
					target: command === "build" ? 'https://api.ts2imba.com': "http://localhost:3000",
					changeOrigin: true
				}
			}
		},
		plugins: [
			imba(),
			monacoEditorPlugin.default({})
		],
		resolve: {
			extensions: ['.imba', '.imba1', '.mjs', '.js', '.ts', '.jsx', '.tsx', '.json']
		},
		test: {
			exclude: ["src/tests/c2js_specs/**/*"],
			globals: true,
			include: ["src/tests/**/*.imba"],
			resolveSnapshotPath: (testPath, snapExtension) => path.join(__dirname, "/src/tests", snapExtension),
		},
	}
});
