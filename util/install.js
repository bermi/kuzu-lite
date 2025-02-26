const os = require("os");
const childProcess = require("child_process");
const path = require("path");
const fs = require("fs");
const fsCallback = require("fs");
const process = require("process");

const platform = process.platform;
const arch = process.arch;
const rootDir = path.join(__dirname, "..");

const prebuiltPath = path.join(
  rootDir,
  "prebuilt",
  `kuzujs-${platform}-${arch}.node`
);

if (fsCallback.existsSync(prebuiltPath)) {
  console.log("Prebuilt binary is available.");
  console.log("Copying prebuilt binary to package directory...");
  fs.copyFileSync(prebuiltPath, path.join(rootDir, "kuzujs.node"));
  console.log(
    `Copied ${prebuiltPath} -> ${path.join(rootDir, "kuzujs.node")}.`
  );
 
  console.log("Done!");
  process.exit(0);
} else {
  console.log("Prebuilt binary is not available, building from source...");
}

