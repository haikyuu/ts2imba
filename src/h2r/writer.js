export function toFileName(delimiter, name) {
  if (delimiter === "") {
    return name;
  }
  return name.replace(/[a-z][A-Z]/g, function(str) {
    return str[0] + delimiter + str[1];
  }).toLowerCase();
}
