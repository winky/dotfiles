const path = require('path')
const fs = require('fs')
const homeDir = require('os').homedir()
const envPath = `${homeDir}/.npm-init.env.js`

const checkFile = (filePath) => {
  try {
    fs.statSync(filePath)
    return true;
  } catch(err) {
    return false;
  }
}

const repositoryMeta = (path) => {
  if (checkFile(path)) {
    const env = require(path)
    const org = env.org

    const isIncules = Object.keys(org).find((key) => process.cwd().toLowerCase().includes(key))
    if (isIncules) {
      return org[isIncules]
    }
  }
  return {}
}

const meta = repositoryMeta(envPath)

const name = path.basename(process.cwd())
const scope = meta.scope || ''
const owner = meta.owner || 'winky'
const license = meta.license || 'MIT'
const private = meta.private || {}

module.exports = {
  name: scope + name,
  ...private,
  version: "0.0.0",
  main: "./dist/index.js",
  author: `${owner} (https://github.com/${owner})`,
  license: license,
  repository: `${owner}/${name}`,
  scripts: {
    prepare: "npm-run-all clean build:*",
    clean: "rm -rf dist",
    lint: "upbin eslint '{src,__tests__}/**/**.{ts,tsx,json,js,jsx}' --cache",
    test: "upbin jest"
  },
  dependencies: {},
  devDependencies: {
    "npm-run-all": "^4.1.5",
    upbin: "^0.9.0"
  }
};