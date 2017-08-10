//
//  ViewController.swift
//  GooglePlacesTestProject
//
//  Created by Artem Chaykovsky on 8/7/17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import UIKit
import MBProgressHUD

class PlacesViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var placesViewModel:PlacesViewModel = PlacesViewModelImpl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        placesViewModel.onPlacesReceived = { [weak self] result in
            switch result {
            case .success:
                self?.tableView.reloadData()
            case .failure(let error):
                self?.showAlert(message: error, title: "Error")
                break
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.navigationController?.navigationBar.isHidden = true
    }

    fileprivate func performSearch(text:String) {
        self.placesViewModel.searchBarDidChange(text:text)
    }

    fileprivate func getPlaceDetails(_ place:Place) {
        showHud()
        placesViewModel.getPlaceDetails(place, completion: { [weak self] result in
            self?.hideHud()
            switch result {
            case .success(details: let placeDetails):
                self?.pushPlaceDetailsWithPlaceDetails(placeDetails)
                break
            case .failure(message: let error):
                self?.showAlert(message: error, title: "Error")
                break
            }
        })
    }

    fileprivate func pushPlaceDetailsWithPlaceDetails(_ placeDetails: PlaceDetails) {
        let placeDetailsVC = PlaceDetailsViewController.newDetailsVCWithPlaceDetails(placeDetails)
        self.navigationController?.pushViewController(placeDetailsVC, animated: true)
    }
}

extension PlacesViewController: UISearchBarDelegate {

    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.characters.count > 0 {
            self.placesViewModel.searchBarDidChange(text:searchText)
            return
        }
        placesViewModel.cancelAllRequests()
        placesViewModel.clearData()
        tableView.reloadData()
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        placesViewModel.cancelAllRequests()
        placesViewModel.clearData()
        tableView.reloadData()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
}

extension PlacesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesViewModel.places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place = placesViewModel.places[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = place.description
        return cell
    }
}

extension PlacesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let place = placesViewModel.placeAtIndex(indexPath.row) {
            self.getPlaceDetails(place)
        }
    }
}

extension UIViewController {

    fileprivate func showAlert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    fileprivate func showHud() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }

    fileprivate func hideHud() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}


