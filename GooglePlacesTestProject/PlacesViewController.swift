//
//  ViewController.swift
//  GooglePlacesTestProject
//
//  Created by Artem Chaykovsky on 8/7/17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import UIKit

class PlacesViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var placesViewModel:PlacesViewModel = PlacesViewModelImpl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView();
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

    func performSearch(text:String) {
        self.placesViewModel.searchBarDidChange(text:text)
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
    }
}

extension UIViewController {

    func showAlert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}


