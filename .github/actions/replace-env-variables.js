const { readFileSync, writeFileSync } = require("fs");

console.log("replacing process.env.* variables");
const contents = readFileSync("worker.js", "utf8");
writeFileSync(
  "worker.js",
  contents.replace(
    /process\.env\.(\w+)/g,
    (match, varName) => `"${process.env[varName]}"`
  )
);
