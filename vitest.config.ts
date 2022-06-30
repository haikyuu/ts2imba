import { defineConfig } from "vitest/config";
import path from 'path'
export default defineConfig({
  test: {
	exclude: ["_dist_esm/tests/c2js_specs/**/*.js"],
    include: ["_dist_esm/tests/**/*.js"],
	resolveSnapshotPath: (testPath, snapExtension) => path.join(__dirname, "/src/tests" , snapExtension),
  },
});
