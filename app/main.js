import { vol } from 'memfs';
import preflight from 'tailwindcss/lib/css/preflight.css?raw'
vol.fromJSON({
  [`${window.__dirname}/css/preflight.css`]: preflight

}, '/')
import "./main.imba"
