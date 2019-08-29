const { readFileSync, writeFileSync } = require("fs");

console.log("replacing process.env.* variables");
const contents = readFileSync("github-oauth-login.js", "utf8");
writeFileSync(
  "github-oauth-login.js",
  contents.replace(
    /process\.env\.(\w+)/g,
    (match, varName) => `"${process.env[varName]}"`
  )
);
