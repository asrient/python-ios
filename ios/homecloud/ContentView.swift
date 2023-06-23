//
//  ContentView.swift
//  homecloud
//
//  Created by Aritra Sen on 22/06/23.
//


import SwiftUI
import PythonKit
import Python

class MyThread: Thread {
    var hc:PythonObject?
    func pyTest(){
        let sys = Python.import("sys")
        print("Python Version: \(sys.version_info.major).\(sys.version_info.minor)")
        print("Python Encoding: \(sys.getdefaultencoding().upper())")
        //print("Python Path: \(sys.path)")

        _ = Python.import("math") // verifies `lib-dynload` is found and signed successfully
    }
    func setupPython() {
        guard let stdLibPath = Bundle.main.path(forResource: "python-stdlib", ofType: nil) else { return }
        guard let pythonLibPath = Bundle.main.path(forResource: "lib", ofType: nil) else { return }
        guard let libDynloadPath = Bundle.main.path(forResource: "python-stdlib/lib-dynload", ofType: nil) else { return }
        setenv("PYTHONHOME", stdLibPath, 1)
        setenv("PYTHONPATH", "\(stdLibPath):\(libDynloadPath):\(pythonLibPath)", 1)
        Py_Initialize()
        // we now have a Python interpreter ready to be used
        print("Python ready to use!");
        print("pythonLibPath", pythonLibPath)
        
        pyTest()
    }
    override func main() { // Thread's starting point
        print("Hi from thread")
        setupPython()
        do {
            hc = try Python.attemptImport("homeCloudIos.main")
        }
        catch {
            print("Could not load `main`", error)
        }
        self.hc?.rund()
        print("Server stopped!");
    }
}

struct ContentView: View {
    var thread: MyThread?
    @State var count: Int = 0
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "hammer")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Developer Menu")
            }
            .padding()
            Text(String(count))
            Button(action: {
                print("Addd");
                count+=1;
                print("New counter:", count)
            }) {
                Text("Add")
            }
        }
    }
    init(){
        print("Test py..")
        thread = MyThread()
        thread!.start()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
