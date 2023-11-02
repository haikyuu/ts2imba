import generate from "babel-generator"

export default function toCode(components) {
  return Object.keys(components).reduce(function(cs, name) {
    cs[name] = generate(components[name].body).code;
    return cs;
  }, {});
}
