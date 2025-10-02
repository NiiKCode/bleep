// esbuild.config.js
const esbuild = require("esbuild");

const watch = process.argv.includes("--watch");

const buildOptions = {
  entryPoints: ["app/javascript/application.js"],
  bundle: true,
  sourcemap: true,
  format: "esm",
  outdir: "app/assets/builds",
  publicPath: "/assets",
  loader: {
    ".css": "css", // ✅ ensures CSS gets bundled
  },
};

async function runBuild() {
  if (watch) {
    let ctx = await esbuild.context(buildOptions);
    await ctx.watch();
    console.log("👀 Watching for changes...");
  } else {
    await esbuild.build(buildOptions);
    console.log("✅ Build complete");
  }
}

runBuild().catch(() => process.exit(1));
