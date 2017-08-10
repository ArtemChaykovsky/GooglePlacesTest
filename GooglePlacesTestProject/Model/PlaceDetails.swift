//
//  PlaceDetails.swift
//  GooglePlacesTestProject
//
//  Created by Artem Chaykovsky on 8/8/17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import UIKit
import JASON

extension JSONKeys {
    static let formattedAddress  = JSONKey<String>("formatted_address")
    static let latitude          = JSONKey<Double>("lat")
    static let longitude        = JSONKey<Double>("lng")
    static let geometry          = JSONKey<JSON>("geometry")
    static let location          = JSONKey<JSON>("location")
    static let photos            = JSONKey<JSON>("photos")
    static let photoReference    = JSONKey<String>("photo_reference")
    static let result            = JSONKey<JSON>("result")
}

struct PlaceDetails {
    var formattedAddress: String?
    var location:Location?
    var photoReference:String?
    var photoUrl:URL?

    init(with json:JSON) {
        configureModelBy(json: json)
    }

    private mutating func configureModelBy(json:JSON) {
        formattedAddress = json[.formattedAddress]
        location         = Location(with:json[.geometry][.location])
        photoReference   = json[.photos][0][.photoReference]
        if let unwrappedPhotoReference = photoReference, unwrappedPhotoReference.characters.count > 0 {
            photoUrl = URL(string: baseUrl + "place/photo?maxwidth=400&photoreference=" + unwrappedPhotoReference + "&key=\(apiKey)")
        }
    }
}

struct Location {
    var latitude: Double?
    var longitude: Double?

    init(with json:JSON) {
        configureModelBy(json: json)
    }

    private mutating func configureModelBy(json:JSON) {
        latitude   = json[.latitude]
        longitude = json[.longitude]
    }
}
