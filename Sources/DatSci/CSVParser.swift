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

enum State {
  case beginningOfLine
  case inCell
  case inQuotedCell
  case maybeAtEnd
  case endOfCell
  case endOfDoc
}

protocol CSVParse {
  
  var state: State { get }
  var cellBuffer: [UInt8] { get set }
  var column: Int { get set }
  var row : Int { get set }
  var inputStream: InputStream { get }
  
  
  var quote: UnicodeScalar { get }
  var newline: UnicodeScalar { get }
  var carriageReturn: UnicodeScalar { get }
  var quoteStr: String { get }
  var delimiter: UnicodeScalar { get }
  var unicodeNul: UnicodeScalar { get }
  
  func valueEncoder()
}

extension CSVParse {
  
  
  mutating func parse() {
    
    
      let reader = ByteReader(inputStream)
      var state: State = .beginningOfLine
      
      while !reader.streamFinished {
        let byte: UInt8
        if let character = reader.fifo() {
          byte = character
        } else {
          break
        }
        let char = Unicode.Scalar(byte)

    
        switch char {
          case delimiter:
            switch state {
            case .beginningOfLine:
              state = .endOfCell
            case .inCell:
              state = .endOfCell
              valueEncoder()
            case .inQuotedCell:
              cellBuffer.append(byte)
            case .maybeAtEnd:
              state = .endOfCell
              valueEncoder()
            case .endOfCell:
              state = .endOfCell
              valueEncoder()
            default:
              assertionFailure("Wrong state")
          }
          
          case newline:
            switch state {
            case .beginningOfLine:
              fallthrough
            case .inCell:
              fallthrough
            case .inQuotedCell:
              cellBuffer.append(byte)
            case .maybeAtEnd:
              fallthrough
            case .endOfCell:
              state = .beginningOfLine
              valueEncoder()
              row += 1
            default:
              assertionFailure("Wrong State")
          }
          
          case quote:
            switch state {
            case .beginningOfLine:
              column = 0
              state = .inQuotedCell
            case .inCell:
              fallthrough
            case .inQuotedCell:
              state = .maybeAtEnd
            case .maybeAtEnd:
              fallthrough
            case .endOfCell:
              state = .inQuotedCell
            default:
              assertionFailure("Wrong State")
          }
          
  //          case carriageReturn:
  //            switch state {
  //              case .beginningOfLine:
  //                fallthrough
  //              case .inCell:
  //                fallthrough
  //              case .inQuotedCell:
  //                cellBuffer.append(byte)
  //              case .maybeAtEnd:
  //                fallthrough
  //              case .endOfCell:
  //                state =
  //              default:
  //                assertionFailure("Wrong state")
  //          }
          
          case unicodeNul:
            switch state {
            case .beginningOfLine:
              fallthrough
            case .inCell:
              fallthrough
            case .inQuotedCell:
              fallthrough
            case .maybeAtEnd:
              fallthrough
            case .endOfCell:
              fallthrough
            default:
              assertionFailure("Wrong State")
          }
            
          default:
            switch state {
            case .beginningOfLine:
              cellBuffer.append(byte)
              column = 0
              state = .inCell
            case .inCell:
              cellBuffer.append(byte)
            case .inQuotedCell:
              cellBuffer.append(byte)
            case .maybeAtEnd:
              break
            case .endOfCell:
              cellBuffer.append(byte)
              state = .inCell
            default:
              assertionFailure("Wrong State")
            }
            
          }
    }
  }
}


public class Parser: CSVParse {

  
  var value: [String] = []
  
  
  var inputStream: InputStream
  var state: State = .beginningOfLine
  var cellBuffer: [UInt8] = [UInt8]()
  var column: Int = 0
  var row: Int = 0
  
  var quote: UnicodeScalar = "\""
  var newline: UnicodeScalar = "\n"
  var carriageReturn: UnicodeScalar = "\r"
  var quoteStr: String = "\""
  var delimiter: UnicodeScalar = ","
  var unicodeNul: UnicodeScalar = Unicode.Scalar(0)
  
  init(_ input: InputStream){
    self.inputStream = input
  }
  
  func valueEncoder() {
    if let string = String(bytes: cellBuffer, encoding: .utf8) {
      self.value.append(string)
    } else {
      assertionFailure("String cannot be encoded")
    }
    self.column += 1
    self.cellBuffer.removeAll()
  }

}


public class ParserToDict: CSVParse {

  
  var value: [String: [String]] = [:]
  var headers: [String]?
  var headerFlag: Bool
  
  var inputStream: InputStream
  var state: State = .beginningOfLine
  var cellBuffer: [UInt8] = [UInt8]()
  var column: Int = 0
  var row : Int = 0
  
  var quote: UnicodeScalar = "\""
  var newline: UnicodeScalar = "\n"
  var carriageReturn: UnicodeScalar = "\r"
  var quoteStr: String = "\""
  var delimiter: UnicodeScalar = ","
  var unicodeNul: UnicodeScalar = Unicode.Scalar(0)
  
  init(_ input: InputStream,
       headers: [String]? = nil,
       headerFlag: Bool = false){
    self.inputStream = input
    self.headerFlag = headerFlag
    if headerFlag {
      self.headers = []
      self.row = -1
    }
  }
  
  func valueEncoder() {
    if let string = String(bytes: cellBuffer, encoding: .utf8) {
      if headers != nil && !headerFlag {
        if value[headers![column]] != nil {
          value[headers![column]]!.append(string)
        } else {
          value[headers![column]] = [string]
        }
         
      } else {
        if headerFlag {
          if row == -1 {
            headers!.append(string)
          } else {
            if value[headers![column]] != nil {
              value[headers![column]]!.append(string)
            } else {
              value[headers![column]] = [string]
            }
          }
        } else {
          if value[String(column)] != nil {
            value[String(column)]!.append(string)
          } else {
            value[String(column)] = [string]
          }
        }
      }
     
    } else {
      assertionFailure("String cannot be encoded")
    }
    column += 1
    cellBuffer.removeAll()
  }
}



class ByteReader {
  
  var inputstream: InputStream
  var buffer = [UInt8]()
  var streamFinished = false
  
  
  init(_ inputstream: InputStream) {
    if inputstream.streamStatus == .notOpen {
      inputstream.open()
    }
    self.inputstream = inputstream
  }
  
  func read(len: Int) -> Int {
    var tempBuffer = [UInt8](repeating: 0, count: len)
    let size = inputstream.read(&tempBuffer, maxLength: tempBuffer.count)
    if size > 0 {
      buffer.append(contentsOf: tempBuffer[0..<size])
    }
    return size
  }
  
  
  func lookAhead(Index: Int = 1) -> UInt8? {
    return buffer[Index]
    
  }
  
  func fifo() -> UInt8? {
    guard buffer.count > 0 else {
      let length = read(len: 100)
      guard length > 0 else {
        streamFinished = true
        return nil
      }
      let value = buffer.first
      buffer.removeFirst()
      return value
    }
    let value = buffer.first
    buffer.removeFirst()
    return value
  }

  
}
