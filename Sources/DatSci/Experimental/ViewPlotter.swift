/**
Copyright Alexander Oldroyd 2020

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import Foundation
import AppKit
import SwiftUI

//TODO: Rewrite copied from Internet
public func GUI() {
  
  let app = NSApplication.shared
  app.setActivationPolicy(.regular)
  
  class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow!
    
    
    
    func applicationDidFinishLaunching(_ notification: Notification) {
      
      
      window = NSWindow(contentRect: NSMakeRect(0,0,800,600),
                        styleMask: [.titled, .unifiedTitleAndToolbar, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                        backing: .buffered,
                        defer: false,
                        screen: nil)
      window.center()
      window.contentView = NSHostingView(rootView: LinePlotView().frame(minWidth: 400))
      //let wrap = NSHostingView(rootView: MySwiftUIView())
      //wrap.frame = window.frame
      window.makeKeyAndOrderFront(nil)
      //let field = NSTextView(frame: window.contentView!.bounds)
      //field.backgroundColor = .white
      //field.isContinuousSpellCheckingEnabled = true
      //window.contentView?.addSubview(wrap)
      //window.title = "Plot"
      
      let toolbarButtons = NSHostingView(rootView: NavBar().padding([.top,.leading,.trailing],25).padding(.bottom,-12.0).edgesIgnoringSafeArea(.top))
      toolbarButtons.frame.size = toolbarButtons.fittingSize
      
      let titlebarAccessory = NSTitlebarAccessoryViewController()
      titlebarAccessory.view = toolbarButtons
      titlebarAccessory.layoutAttribute = .trailing
      window.toolbar = NSToolbar()
      //window.toolbar = .init()
      window.titleVisibility = .hidden
      window.addTitlebarAccessoryViewController(titlebarAccessory)
      
      //DispatchQueue(label: "background").async {
        
      //}
    }
  }

  let delegate = AppDelegate()
  app.delegate = delegate
  app.run()
}
