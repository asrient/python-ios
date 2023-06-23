# Python - Swift Interop using PythonKit

Exploring embedding a python HTTP and Websockets server inside an iOS app (swift) using PythonKit.

## Notes

- Support seems lagging. `PythonKit` provides a wrapper to use cPython directly from Swift. `beeware/Python-Apple-support` provides binaries to embed cPython inside ios app. Checkout their usage guide to setup the xcode project properly.
- Due to cPython's GIL implementation it is not possible to access python from 2 diffrent threads from swift side. Doing so was resulting in ERR_BAD_ACCESS. To run a server we cannot afford to block the main UI thread or else our UI will be unresponsive. Only thing that worked for me was to initalize python interpretor from a new thread instead on swift side and avoid accessing python from the main thread.
- Used AIOHTTP library for http & websocket server on python.
- To install a 3rd pary pip package use:

```bash
pip install --target=ios/lib <package name>
```
- Python code lives in `ios/lib/homeCloudIos`
- Memory usage of app on emulator was around 64MB. Mem usage with minimum python setup (no external python packages) was around 40MB.
- Around 10 threads were observed.

## Resources

- https://medium.com/swift2go/embedding-python-interpreter-inside-a-macos-app-and-publish-to-app-store-successfully-309be9fb96a5
- https://github.com/beeware/Python-Apple-support
- https://docs.aiohttp.org/en/stable/web_quickstart.html
- https://www.tensorflow.org/swift/guide/python_interoperability
- https://github.com/pvieito/PythonKit
- https://github.com/stefanspringer1/SwiftHelloPython
- https://betterprogramming.pub/from-swift-import-python-f2fc2a997d4

