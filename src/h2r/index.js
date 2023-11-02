import {parser} from "posthtml-parser"
import htmlToReactComponentsLib from "./processor"
// console.log("::r", parse)
export default function extractReactComponents(html, options) {
  options = options || {};
  var components = htmlToReactComponentsLib(parser(html), options);
  return components;
};
