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
    
    public func fetchMovies(completion: @escaping([Movie])->Void){
        
        let url = "https://api.themoviedb.org/3/discover/movie?api_key=3e75df12dc9c5765ebf902dad62c5087"
        
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
