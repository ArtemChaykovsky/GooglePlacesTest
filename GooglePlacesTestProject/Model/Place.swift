//
//  Place.swift
//  GooglePlacesTestProject
//
//  Created by Artem Chaykovsky on 8/7/17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import UIKit
import JASON

extension JSONKeys {
    static let description  = JSONKey<String>("description")
    static let id           = JSONKey<String>("id")
    static let place_id     = JSONKey<String>("place_id")
    static let reference    = JSONKey<String>("reference")
    static let predictions  = JSONKey<JSON>("predictions")
    static let status       = JSONKey<String>("status")
    static let errorMessage = JSONKey<String>("error_message")
}


 struct Place {

    var description: String?
    var id: String?
    var place_id: String?
    var reference: String?

    init(with json:JSON) {
        configureModelBy(json: json)
    }

    private mutating func configureModelBy(json:JSON) {
        description = json[.description]
        id          = json[.id]
        place_id    = json[.place_id]
        reference   = json[.reference]
    }

}
