//
//  PlaceDetailsViewController.swift
//  GooglePlacesTestProject
//
//  Created by Artem Chaykovsky on 8/8/17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import UIKit

let placeDetailsVC = "PlaceDetailsVC"

class PlaceDetailsViewController: UIViewController {

    fileprivate var placeDetails: PlaceDetails!
    @IBOutlet weak var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Place details"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
}

extension PlaceDetailsViewController: UITableViewDataSource {

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.numberOfLines = 0
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Address:  \(self.placeDetails.formattedAddress ?? "n/a")"
        case 1:
            cell.textLabel?.text = "Longitude:  \(self.placeDetails.location?.longitude?.description ?? "n/a")"
        case 2:
            cell.textLabel?.text = "Latitude:  \(self.placeDetails.location?.latitude?.description ?? "n/a")"
        case 3:
            let placeDetailsCell = tableView.dequeueReusableCell(withIdentifier: String(describing:PlacePhotoTableViewCell.self))! as! PlacePhotoTableViewCell
            placeDetailsCell.setPhotoFromPlaceDetails(placeDetails)
            return placeDetailsCell
        default:
            break
        }
        return cell
    }
}

extension PlaceDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < 3 {
            return UITableViewAutomaticDimension
        }
        return 270
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension PlaceDetailsViewController {
    static func newDetailsVCWithPlaceDetails(_ placeDetails: PlaceDetails) -> PlaceDetailsViewController {
        let placeDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing:self)) as! PlaceDetailsViewController
        placeDetailsVC.placeDetails = placeDetails
        return placeDetailsVC
    }
}
