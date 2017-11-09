# Mocha & CoffeeScript Boilerplate

This fork of the [mocha-coffeescript-browser-boilerplate](https://github.com/quartzmo/mocha-coffeescript-browser-boilerplate) (provided by @quartzmo) intends to allow for both Command Line and Browser usage of [Mocha](https://mochajs.org/) testing framework in a single approach.

This is attempted by adding additional boilerplate code to initiate a platform agnostic global variable and a simple existential check for the [Node.js](http://nodejs.org/) require method:

```js
root = typeof window !== "undefined" && window !== null ? window : global;
```

```js
if (typeof require !== "undefined" && require !== null) require("../example");
``` 

## Usage:

1. `rm -rf .git`
2. Replace `example.coffee` in both `test` and `src` with your own code.
3. `make` to compile source and test CoffeeScript, or else `make watch` and `make test-watch` for automatic compilation
4. Edit `Readme.md`, replacing this project's details with your own.
5. `npm install` for dependencies

### JSCoverage:

If you'd like to utilize [JSCoverage](http://siliconforks.com/jscoverage/), you'll have to utilize a little bit more boilerplate code that's shown in the example-test, (`process.env["EXAMPLE_NAME_SPACE"] ? "../lib-cov" : "../lib"`) which is tells Mocha to utilize the JSCoverage version of your source code.

(Installing JSCoverage cannot be done through NPM, so using Homebrew is my recommendation: $ `brew install jscoverage`)

1. `make all` or create your source and tests as you normally would
2. `make test-cov` to generate the test/coverage.html

## Note on CoffeeScript

CoffeeScript is not listed as a dependency within the NPM package.json. This is because in order to use the Makefile's CoffeeScript shortcuts, you'll have to have CoffeeScript installed globally (`npm install coffee-script -g`) for use in the command line.

If anyone has an idea on how to best approach solving this using NPM package.json configuration please ping me. 

## Via mocha-coffeescript-browser-boilerplate:

A minimalistic boilerplate for a browser-based CoffeeScript project that is tested with [visionmedia/mocha](https://mochajs.org/).
Uses Chai instead of Should for browser compatibility.

Requires CoffeeScript's `coffee` executable in path for make compilation. CoffeeScript, NPM, and Node are **not** required for the browser-based test run.

### Usage

1. `rm -rf .git`
1. Replace `example.coffee` in both `test` and `src` with your own code.
1. `make` to compile source and test CoffeeScript, or else `make watch` and `make test-watch` for automatic compilation
1. Edit `Readme.md`, replacing this project's details with your own.

### License

The MIT License

Copyright (c) 2012 Chris Smith

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
