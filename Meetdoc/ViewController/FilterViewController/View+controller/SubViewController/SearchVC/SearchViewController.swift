//
//  SearchViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 13/02/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
//import GooglePlacePicker
import DropDown
protocol searchFilterDelegate {
    func searchFilterAct(filterStruct: FilterData, title: String)
}
class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var shadowView: UIView!
    var searchArr = [locationData]()
    var currentString = ""
    let dropDown = DropDown()
    var fetcher: GMSAutocompleteFetcher?
    var placesClient: GMSPlacesClient!
    var SelectedCoordination = CLLocationCoordinate2D()
    var locationArray = NSMutableArray()
    var delegate: searchFilterDelegate?
    var filterStruct = FilterData()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkReachability()
                // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customUI()
    }
    func customUI() {
        tableView.tableFooterView = UIView()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        fetcher = GMSAutocompleteFetcher.init()
        fetcher?.delegate = self
        self.searchTextField.config(color: UIColor(named: "TitleColor") ?? .white, align: .left, placeHolder: "where_to", Font: fontsemi25)
        self.searchTextField.attributedPlaceholder = NSAttributedString(string: Utility().language().value(forKey: "where_to") as? String ?? "",attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "fifth_text") ?? .white])
        
        self.fetcher?.autocompleteFilter?.type = .city
        self.searchTextField.text = currentString
        self.shadowForView()
        self.loadData()
    }
    func shadowForView() {
        shadowView.layer.cornerRadius = 3
        shadowView.layer.shadowColor = (UIColor(named: "fifth_text") ?? .white).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowOpacity = 0.3
    }
    func loadData() {
        self.searchArr = UserDefaultModule.shared.getLocationSearch()
        self.tableView.reloadData()
    }
    @IBAction func closeButtonAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension searchFilterDelegate {
    func searchFilterAct(filterStruct: FilterData, title: String) {
        
    }
}
extension SearchViewController:  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.config(color: UIColor(named: "TitleColor") ?? .white, font: regularFont, align: .left, text: "")

        cell?.textLabel?.text = self.searchArr[indexPath.row].location_search
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let filterStruct = FilterData(user_id: "\((UserDefaultModule().getCurrentUserID()!))", search_key: "search", lat: self.searchArr[indexPath.row].lat, lon: self.searchArr[indexPath.row].long, searchtype: "search")
//        filterStruct.lat = self.searchArr[indexPath.row].lat
//        filterStruct.lon = self.searchArr[indexPath.row].long
        self.delegate?.searchFilterAct(filterStruct: filterStruct, title: self.searchArr[indexPath.row].location_search)
    }
}

//MARK: Location auto complete fetcher
extension SearchViewController: GMSAutocompleteFetcherDelegate, UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.dropDown.hide()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji {
                   return false
               }
        fetcher?.sourceTextHasChanged(textField.text!+string)
        return true
    }
    func configLocationDropDownView() {
        dropDown.anchorView = self.searchTextField // UIView or UIBarButtonItem
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.width = self.searchTextField.frame.width
        var countryArray = [String]()
        for country in self.locationArray {
            let countryDict = country as! Dictionary<String, Any>
            countryArray.append(countryDict["address_full"] as? String ?? "")
        }
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = countryArray
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.searchTextField.resignFirstResponder()
            self.searchTextField.text = item
            let countryDict = self.locationArray[index] as! Dictionary<String, Any>
            if self.searchArr.filter({$0.location_search == countryDict["location_search"] as? String ?? ""}).count == 0 {
                self.getPlaceDetails(countryDict)
            }
        }
    }
    func getPlaceDetails(_ countryDict: Dictionary<String, Any>) {
        let placeID = countryDict["placeID"] as? String ?? ""
        
        let placeClient = GMSPlacesClient.shared()
        placeClient.lookUpPlaceID(placeID) { (fields, error) in
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
            }
            if let place = fields {
                self.SelectedCoordination = place.coordinate
                self.searchArr.append(locationData(lat: "\(self.SelectedCoordination.latitude)", long: "\(self.SelectedCoordination.longitude)", location_search: countryDict["address_full"] as? String ?? ""))
                UserDefaultModule.shared.setLocationSearch(self.searchArr)
                DispatchQueue.main.async {
                    self.delegate?.searchFilterAct(filterStruct: self.filterStruct, title: countryDict["address_full"] as? String ?? "")
                }
            }
        }
    }
    func didFailAutocompleteWithError(_ error: Error) {
        print("Did Fail Auto Complete With Error :\(error.localizedDescription)")
        
    }
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        self.locationArray.removeAllObjects()
        for prediction in predictions{
            let mutableDict = NSMutableDictionary()
            print("prediction value in predictions : \(prediction)")
            mutableDict.setValue(prediction.attributedPrimaryText.string, forKey: "address_first")
            mutableDict.setValue(prediction.attributedSecondaryText?.string, forKey: "address_second")
            mutableDict.setValue(prediction.placeID, forKey: "placeID")
            mutableDict.setValue(prediction.attributedFullText.string, forKey: "address_full")
            self.locationArray.addObjects(from: [mutableDict])
        }
        if self.locationArray.count == 0
        {
            self.dropDown.hide()
        }
        else
        {
            configLocationDropDownView()
            if self.dropDown.isHidden {
                self.dropDown.show()
            }
        }
    }
    
    func getPlaceDetails(_ placeID: String) {
        let placeClient = GMSPlacesClient.shared()
        placeClient.lookUpPlaceID(placeID) { (fields, error) in
             if let error = error {
               print("An error occurred: \(error.localizedDescription)")
               return
             }
             if let place = fields {
                self.SelectedCoordination = place.coordinate
             }
        }
    }
    private func locale(for fullCountryName : String) -> String {
        let locales : String = ""
        for localeCode in NSLocale.isoCountryCodes {
            let identifier = NSLocale(localeIdentifier: localeCode)
            let countryName = identifier.displayName(forKey: NSLocale.Key.countryCode, value: localeCode)
            if fullCountryName.lowercased() == countryName?.lowercased() {
                return localeCode
            }
        }
        return locales
    }
}
