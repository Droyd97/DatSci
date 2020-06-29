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

import SwiftUI

struct Line: View {
  init() {}
  var body: some View{
    GeometryReader { geometry in
      Path { p in
        let width = min(geometry.size.width,geometry.size.height)
        let height = 0.75 * width
        let middle = width / 2
        
        p.move(to: CGPoint(x: width * 0.2 , y:0))
        p.addLine(to: CGPoint(x: middle, y: height))
      }.stroke(Color.red)
    }
  }
  
}
