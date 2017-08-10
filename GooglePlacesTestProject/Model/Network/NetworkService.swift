//
//  NetworkService.swift
//  GooglePlacesTestProject
//
//  Created by Artem Chaykovsky on 8/7/17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import UIKit
import Alamofire

let apiKey  = "AIzaSyD7MEz0aLK96kC3qB2HZpgPip_W3cYlhm4"
let baseUrl = "https://maps.googleapis.com/maps/api/"

class NetworkService {

    static let shared:NetworkService = NetworkService()

    func fetchPlaces(searchValue:String,completion:@escaping (Result<Any>)->()) {
        let escaped = searchValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        performRequest(url: baseUrl + "place/autocomplete/json?input=\(escaped)&key=\(apiKey)" ) { (result) in
            completion(result)
        }
    }

    func getPlaceDetais(_ place:Place, completion:@escaping (Result<Any>)->()) {
        performRequest(url: baseUrl + "place/details/json?placeid=\(place.place_id ?? "")&key=\(apiKey)") { (result) in
            completion(result)
        }
    }

    fileprivate func performRequest(url:String,completion:@escaping (Result<Any>)->()) {
        Alamofire.request(url).responseJSON { (response) in
            completion(response.result)
        }
    }

    func cancelAll() {
        Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
            tasks.forEach{$0.cancel()
            }
        }
    }
}
