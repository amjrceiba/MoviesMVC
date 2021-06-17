//
//  Networking.swift
//  MoviesMVC
//
//  Created by Andrés Mauricio Jaramillo Romero - Ceiba Software on 15/06/21.
//

import Foundation
import Alamofire
import SwiftyJSON

public class Networking {
    
    let preferences: Preferences?
    
    init() {
        let path = Bundle.main.path(forResource: "Preferences", ofType: "plist")
        let xml = FileManager.default.contents(atPath: path!)
        self.preferences = try? PropertyListDecoder().decode(Preferences.self, from: xml!)
    }
    
    public func fetchMovies(completion: @escaping([Movie])->Void){
        
        let url = "\(preferences?.baseUrl ?? "")\(preferences?.discover ?? "")\(preferences?.apiKey ?? "")"
        
        get(url: url) { response in
            if (response.error != nil){
                return
            }
            
            print(response)
            
            let json = JSON(response.data!)
            let data = json["results"].array
            let movies = try! JSONDecoder().decode([Movie].self, from: JSON(data!).rawData())
            
            completion(movies)
        }
    }
    
    private func get(url: String, completion: @escaping(AFDataResponse<Any>)->Void){
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        AF.request(request).responseJSON { response in
            completion(response)
        }
    }
    
}


