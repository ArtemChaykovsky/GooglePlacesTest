//
//  PlacePhotoTableViewCell.swift
//  GooglePlacesTestProject
//
//  Created by Artem Chaykovsky on 8/9/17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import UIKit


class PlacePhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    var photoUrl: String?

    func setPhotoFromPlaceDetails(_ place:PlaceDetails) {
        if let url = place.photoUrl {
            if let data = try? Data(contentsOf: url){
                photoImageView.image = UIImage(data: data)
                return
            }        
        }
        photoImageView.image = UIImage(named: "imagePlaceholder")
    }
}
