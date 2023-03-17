import { build, defineConfig } from 'vite';
import { resolve } from 'path'
import { builtinModules } from 'module'
import monacoEditorPlugin from "vite-plugin-monaco-editor"
import path from 'path'

export default defineConfig(({ command, mode }) => {
	return {
		bundler: 'vite',
		client: {
			build: {
				rollupOptions: {
					external: ['esbuild'],
				},
				target: ['esnext'],
			},
			target: ['chrome89', 'edge89' ,'safari15', 'firefox89'],
			plugins: [monacoEditorPlugin.default({
				languageWorkers: ['editorWorkerService', 'typescript']
			})],
			define: {
				__dirname: 'import.meta.url',
				__filename: 'import.meta.url',
				'process.platform': "'not win 32'",
				'process.versions.node': "'16.12.0'"
			},
			resolve: {
				alias: {
					// process: 'process/browser',
					process: 'node_modules/@jspm/core/nodelibs/browser/process.js',
					path: 'node_modules/@jspm/core/nodelibs/browser/path.js',
					stream: 'node_modules/@jspm/core/nodelibs/browser/stream.js',
					// worker_threads: 'node_modules/@jspm/core/nodelibs/browser/worker_threads.js',
					crypto: 'node_modules/@jspm/core/nodelibs/browser/crypto.js',
					url: 'node_modules/@jspm/core/nodelibs/browser/url.js',
					events: 'node_modules/@jspm/core/nodelibs/browser/events.js',
					util: 'node_modules/@jspm/core/nodelibs/browser/util.js',
					fs: 'memfs',
					os: 'node_modules/@jspm/core/nodelibs/browser/os.js',
					'source-map-js': 'node_modules/source-map-js/source-map.js',
				},
				}
		},
		test: {
			exclude: ["src/tests/c2js_specs/**/*"],
			globals: true,
			include: ["src/tests/**/*.imba"],
		}
	}
});
