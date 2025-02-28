const path = require("path");
const process = require("process");
const fs = require("fs");
const https = require("https");
const { HttpsProxyAgent } = require('https-proxy-agent');

const arch = process.arch;
const rootDir = path.join(__dirname, "..");

let platform = process.platform;
const isAlpine = platform == "linux" && fs.readFileSync('/etc/os-release', 'utf8').includes('Alpine Linux');
if (isAlpine) {
  platform = "alpine";
}

const baseURL = "https://raw.githubusercontent.com/Kineviz/kuzu-lite/refs/heads/master/prebuilt";
const prebuiltURL = `${baseURL}/kuzujs-${platform}-${arch}.node`;

console.log(`Downloading prebuilt binary from ${prebuiltURL}...`);

const targetPath = path.join(rootDir, "kuzujs.node");

const download = (url, dest) => {
  return new Promise((resolve, reject) => {
    const file = fs.createWriteStream(dest);
    const proxy = process.env.HTTP_PROXY;
    const agent = proxy ? new HttpsProxyAgent(proxy) : undefined;

    const reqOptions = { agent };

    https.get(url, reqOptions, (response) => {
      if (response.statusCode !== 200) {
        reject(new Error(`Failed to download: ${response.statusCode} ${response.statusMessage}`));
        return;
      }

      response.pipe(file);

      file.on('finish', () => {
        file.close(() => resolve());
      });
    }).on('error', (err) => {
      fs.unlink(dest, () => {});
      reject(err);
    });
  });
};

download(prebuiltURL, targetPath)
  .then(() => {
    console.log(`Successfully downloaded to ${targetPath}`);
    console.log("Done!");
    process.exit(0);
  })
  .catch((err) => {
    console.error(`Error downloading prebuilt binary: ${err.message}`);
    console.log("Prebuilt binary download failed, building from source...");
  });