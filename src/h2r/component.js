import * as t from "babel-types"
import * as walk from "babylon-walk"

function props(publics, propsType) {
  if (propsType === "class") {
    return t.variableDeclaration("const", [
      t.variableDeclarator(
        t.objectPattern(
          publics.map(
            (prop) => t.objectProperty(
              t.identifier(prop[0]),
              t.identifier(prop[0]),
              false,
              true
            )
          )
        ),
        t.memberExpression(t.thisExpression(), t.identifier("props"))
      )
    ]);
  }
  if (propsType === "functional") {
    return [
      t.objectPattern(
        publics.map(
          (prop) => t.objectProperty(
            t.identifier(prop[0]),
            t.identifier(prop[0]),
            false,
            true
          )
        )
      )
    ];
  }
}
function toES5Component(name, jsxElement) {
  return t.variableDeclaration("const", [
    t.variableDeclarator(
      t.identifier(name),
      t.callExpression(
        t.memberExpression(t.identifier("React"), t.identifier("createClass")),
        [
          t.objectExpression([
            t.objectMethod(
              "method",
              t.identifier("render"),
              [],
              t.blockStatement([t.returnStatement(jsxElement)])
            )
          ])
        ]
      )
    )
  ]);
}
function toES6Component(name, jsxElement, publics) {
  var block = publics.length ? t.blockStatement([props(publics, "class"), t.returnStatement(jsxElement)]) : t.blockStatement([t.returnStatement(jsxElement)]);
  return t.classDeclaration(
    t.identifier(name),
  	undefined,
    t.classBody([t.classMethod("method", t.identifier("render"), [], block)]),
    []
  );
}
function toStatelessComponent(name, jsxElement, publics) {
  var params = publics.length ? props(publics, "functional") : [];
  return t.variableDeclaration("const", [
    t.variableDeclarator(
      t.identifier(name),
      t.arrowFunctionExpression(params, jsxElement)
    )
  ]);
}
function getAST(name, expr, publics, componentType) {
	console.log("::", name, expr, publics, componentType)
  if (componentType === "es5") {
    return toES5Component(name, expr);
  }
  if (componentType === "class") {
    return toES6Component(name, expr, publics);
  }
  if (componentType === "functional") {
    return toStatelessComponent(name, expr, publics);
  }
}
function replacePublicAttrs(expr) {
  var publics = [];
  expr.openingElement.attributes.forEach((attr) => {
    if (attr.name.hasOwnProperty("namespace") && attr.name.namespace.name === "public") {
      var value = attr.value;
      attr.name = attr.name.name;
      attr.value = t.jSXExpressionContainer(t.identifier(attr.name.name));
      publics.push([attr.name.name, value]);
    }
  });
  return { expr, publics };
}
function enrichWithPublics(body, publics, child) {
  walk.simple(body, {
    JSXOpeningElement(p) {
      if (p.name.name === child) {
        publics.forEach(([attr, value]) => {
          p.attributes.push(
            t.jSXAttribute(
              t.jSXIdentifier(attr),
              t.jSXExpressionContainer(value)
            )
          );
        });
      }
    }
  });
  return body;
}
export default function toReactComponents(componentType, components) {
  var components = Object.keys(components).reduce(function(cs, name) {
    components[name].forEach((component) => {
      var { expr, publics } = replacePublicAttrs(
        component.body.program.body[0].expression
      );
      cs[name] = cs[name] || [];
	  let displayName =  name.replace(/([a-z0-9]|(?=[A-Z]))([A-Z])/g, '$1-$2').toLowerCase()
	  console.log("::displayName", displayName, name)
	  if(displayName.indexOf('-') == -1) displayName = 'q-' + displayName
      cs[name].push({
        body: getAST(name, expr, publics, componentType),
        children: component.children,
        publics: component.publics,
		displayName,
      });
    });
    return cs;
  }, {});
  Object.values(components).forEach((parents) => {
    parents.forEach((parent) => {
      Object.keys(components).forEach((child) => {
        components[child].forEach((child2) => {
          var publics = child2.publics;
          if (parent.children.includes(child2) && publics.length) {
            enrichWithPublics(parent.body, publics, child2);
          }
        });
      });
    });
  });
  return components;
}
