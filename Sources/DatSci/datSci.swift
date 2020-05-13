import Foundation

final public class datSci {

  public static func jsonToDataFrame<T,V>(data: Foundation.Data, model: T.Type, path: KeyPath<T,V> ) -> DataFrame  where T: Codable {
    var newDataFrame: DataFrame = [:]
    do{
      let decoder = JSONDecoder()
      let json = try decoder.decode(model, from: data)
      let jsonData = json[keyPath:path]
      let structMirror = Mirror(reflecting: jsonData)
      for struc in structMirror.children{
        let childMirror = Mirror(reflecting: struc.value)
        print(childMirror.children)
        for child in childMirror.children{
          guard newDataFrame.data[child.label!] != nil else{
            newDataFrame.data[child.label!] = [child.value]
            newDataFrame.headers.append(child.label!)
            newDataFrame.dataTypes.append(type(of:child.value))
            continue
          }

          guard newDataFrame.dataTypes[newDataFrame.headers.firstIndex(of: child.label!)!] == type(of:child.value) else {
            fatalError("Data types do not match")
          }
          newDataFrame.data[child.label!]!.append(child.value)
          
        }
        newDataFrame.totalRows += 1
      }
    } catch{
      print("Error with Conversion")
    }
    newDataFrame.addIndex()
    return newDataFrame
  }

  internal static func ApiCall(url: URL, completion: @escaping (Foundation.Data?) -> ()) {
    let session = URLSession.shared
    let task = session.dataTask(with: url, completionHandler: {data, response, error in
        if( error != nil){
            print("Error:")
            completion(nil)
        } else {
          completion(data!)
          exit(EXIT_SUCCESS)
        }
    })
    task.resume()
    dispatchMain()
  }
}
