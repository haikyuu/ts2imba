import api from "posthtml/lib/api"
import {render} from "posthtml-render"
import toJsxAST from "./jsx"
import toReactComponents from "./component"
import toModules from "./module"
import toCode from "./code"
import formatCode from "./format"

function camelToSnake(string) {
    return string.replace(/([a-z])([A-Z])/g, '$1_$2').toLowerCase();
}
function getComponentName(node) {
  return node.attrs["data-component"];
}
function removeComponentName(node) {
  delete node.attrs["data-component"];
  return node;
}
function isComponent(node) {
  var annotated = node.attrs && getComponentName(node);
  if (annotated !== void 0) {
    if (getComponentName(node).length > 0) {
      return true;
    } else {
      throw Error("There's annotated component without a name!");
    }
  }
  return false;
}
function collectComponents(components) {
  return function(node) {
    if (isComponent(node)) {
      components.push(node);
    }
    return node;
  };
}
function clearAndRenderComponents(component) {
  component[1] = render(removeComponentName(component[1]));
  return component;
}
function assignByName(component) {
  return [getComponentName(component), component];
}
function mergeByName(components) {
  return components.reduce(function(cs, component) {
    cs[component[0]] = component[1];
    return cs;
  }, {});
}
function mergeByInstance(components) {
  return components.reduce(function(cs, component) {
    cs[component[0]] = cs[component[0]] || [];
    cs[component[0]].push(component[1]);
    return cs;
  }, {});
}
export default function htmlToReactComponentsLib(tree, options) {
  var componentType = options.componentType;
  var moduleType = options.moduleType;
  if (componentType !== "functional" && componentType !== "es5" && componentType !== "class") {
    componentType = "functional";
  }
  if (moduleType !== "es" && moduleType !== "cjs") {
    moduleType = "es";
  }
  var components = [];
  var delimiter = options.moduleFileNameDelimiter || "";
  api.walk.bind(tree)(collectComponents(components));
  var reactComponents = toReactComponents(
    componentType,
    toJsxAST(
      mergeByInstance(
        components.map(assignByName).map(clearAndRenderComponents)
      )
    )
  );
  if (moduleType) {
    return formatCode(
      toCode(toModules(moduleType, delimiter, reactComponents))
    );
  }
  return formatCode(toCode(reactComponents));
}
