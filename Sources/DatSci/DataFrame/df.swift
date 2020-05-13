import Foundation 

public struct readJson{
  func readJson(){

  }

  
  func jsonApiCall<T>(url: URL, model: T.Type, completion: @escaping (T?) -> ()) where T : Decodable {
    let session = URLSession.shared
    let task = session.dataTask(with: url, completionHandler: {data, response, error in
        if( error != nil){
            print("Error:")
            completion(nil)
        } else {
            do{
            let decoder = JSONDecoder()
            let json: T = try decoder.decode(model, from: data!)
            completion(json)
            exit(EXIT_SUCCESS)
            } catch{
                completion(nil)
                print("error")
                exit(EXIT_SUCCESS)
            }
        }
    
    })
    task.resume()
    dispatchMain()
  } 
}