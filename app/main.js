import { vol, fs } from "memfs";

import process from "process/browser";
import preflight from "tailwindcss/lib/css/preflight.css?raw";

fetch("/manifest.json")
  .then(async (res) => {
    const manifest = await res.json();
		const key = Object.keys(manifest).find(k=> /_main-.*\.js/.test(k))

		console.log("manifest", key, manifest[key])

    const main = manifest[key].file;

    const link = `${location.href}${main}/css/preflight.css`;

    const p =
      import.meta.env.MODE == "production"
        ? link
        : `/preflight.css`;

		console.log("Rrr", p)
    vol.fromJSON(
      {
        [p]: preflight,
      },
      "/"
    );
    window.process = process;
    process.versions = { node: "16.12.0" };
    import("./main.imba");
  })
  .catch((e) => {
    // dev -____-

    const p = `${window.__dirname}/css/preflight.css`;
		console.log("ppp", p)
    vol.fromJSON(
      {
        [p]: preflight,
      },
      "/"
    );
    window.process = process;
    process.versions = { node: "16.12.0" };
    import("./main.imba");
  });
