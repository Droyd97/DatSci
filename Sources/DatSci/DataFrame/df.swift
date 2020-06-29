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

// TODO: Build ability to call JSON/CSV and return DataFrame
import Foundation
//
//public struct readJson{
//  func readJson(){
//
//  }
//
//  
//  func jsonApiCall<T>(url: URL, model: T.Type, completion: @escaping (T?) -> ()) where T : Decodable {
//    let session = URLSession.shared
//    let task = session.dataTask(with: url, completionHandler: {data, response, error in
//        if( error != nil){
//            print("Error:")
//            completion(nil)
//        } else {
//            do{
//            let decoder = JSONDecoder()
//            let json: T = try decoder.decode(model, from: data!)
//            completion(json)
//            exit(EXIT_SUCCESS)
//            } catch{
//                completion(nil)
//                print("error")
//                exit(EXIT_SUCCESS)
//            }
//        }
//    
//    })
//    task.resume()
//    dispatchMain()
//  } 
//}
