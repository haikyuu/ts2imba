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
		plugins: [
			imba(),
			monacoEditorPlugin.default({})
		],
		resolve: {
			extensions: ['.imba', '.imba1', '.mjs', '.js', '.ts', '.jsx', '.tsx', '.json']
		},
		ssr: true,
		build: {
			ssrManifest: true,
			manifest: true,
			minify: true,
			rollupOptions: {
				output: {
					dir: "./dist",
					name: "main",
				},
				input: {
					entry,
				},
			}
		},
		test: {
			exclude: ["src/tests/c2js_specs/**/*"],
			globals: true,
			include: ["src/tests/**/*.imba"],
			resolveSnapshotPath: (testPath, snapExtension) => path.join(__dirname, "/src/tests", snapExtension),
		},
		server: {
			watch: {
				// During tests we edit the files too fast and sometimes chokidar
				// misses change events, so enforce polling for consistency
				usePolling: true,
				interval: 100
			}
		}
	}
});
