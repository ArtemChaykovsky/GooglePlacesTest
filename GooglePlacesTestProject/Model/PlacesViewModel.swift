//
//  FetchPlacesViewModel.swift
//  GooglePlacesTestProject
//
//  Created by Artem Chaykovsky on 8/7/17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import UIKit
import JASON

enum PlacesResult {
    case success
    case failure(message:String)
}

enum PlaceDetailsResult {
    case success(details:PlaceDetails)
    case failure(message:String)
}

protocol PlacesViewModel {

    var onPlacesReceived:(PlacesResult)->() { get set }
    var places:[Place]{ get }
    func searchBarDidChange(text:String)
    func cancelAllRequests()
    func clearData()
    func placeAtIndex(_ index:Int) -> Place?
    func getPlaceDetails(_ place:Place, completion:@escaping (PlaceDetailsResult)->()) ->()
}

class PlacesViewModelImpl: PlacesViewModel {

    var places:[Place] = []

    var onPlacesReceived:(PlacesResult)->() = {_ in}

    func searchBarDidChange(text:String) {
        cancelAllRequests()
        NetworkService.shared.fetchPlaces(searchValue: text) {[weak self] result in
            switch result {
            case .success(let value):
                let json = JSON(value)
                self?.places = json[.predictions].map{Place(with:$0)}
                self?.onPlacesReceived(.success)
                break
            case .failure(let error):
                if error.code != -999 { //request cancelled
                    self?.onPlacesReceived(.failure(message: error.localizedDescription))
                }
                break
            }
        }
    }

    func getPlaceDetails(_ place: Place, completion:@escaping (PlaceDetailsResult)->()) {
        NetworkService.shared.getPlaceDetais(place) { result in
            switch result {
            case .success(let value):
                let json = JSON(value)
                let placeDetails = PlaceDetails(with: json[.result])
                completion(.success(details: placeDetails))
                break
            case .failure(let error):
                completion(.failure(message: error.localizedDescription))
                break
            }

        }
    }

    func cancelAllRequests() {
        NetworkService.shared.cancelAll()
    }

    func clearData() {
        places.removeAll()
    }

    func placeAtIndex(_ index: Int) -> Place? {
        return places[index]
    }

}

extension Error {
    var code: Int { return (self as NSError).code }
}

