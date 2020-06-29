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

precedencegroup PowerPrecedence {higherThan: MultiplicationPrecedence}

infix operator .^^: PowerPrecedence

infix operator ^^: PowerPrecedence

infix operator .*: MultiplicationPrecedence

infix operator ./: MultiplicationPrecedence

public func ^^ (element: Double , power: Double) -> Double{

  if element < 0 {
    let value = abs(element)
    return -pow(value, power)
  }
  return pow(element, power)
}

public func ^^ (element: Double , power: Int) -> Double{
  return pow(element, Double(power))
}
