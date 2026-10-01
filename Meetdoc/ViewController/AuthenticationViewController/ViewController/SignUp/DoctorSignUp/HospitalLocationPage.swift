 //
 //  HospitalLocationPage.swift
 //  Meetdoc
 //
 //  Created by Arun Andiselvam on 25/09/20.
 //  Copyright © 2020 BTMani. All rights reserved.
 //
 
 import UIKit
 import GoogleMaps
 import GooglePlaces
 
 protocol select_Location {
    func locationData(_ location: LocationModel)
    func locationDetails(_ location: String, lat: String, long: String, countryCode: String)
    
 }
 class HospitalLocationPage: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    
    var delegate: select_Location?
    var selectedHospital: HospitalResultModel?
    var selectedLocation: LocationModel?
    var fetcher: GMSAutocompleteFetcher?
    var placesClient: GMSPlacesClient!
    var filterPlaces = [GMSAutocompletePrediction]()
    var selectedPrediction: GMSAutocompletePrediction?
    var isFromHospital = false
    var isFromPatientProfile = false
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.configUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    func configUI() {

        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "location") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)

        self.tableView.register(UINib(nibName: "SelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectionTableViewCell")
        
        fetcher = GMSAutocompleteFetcher.init()
        fetcher?.delegate = self
        let fetcherFilter = GMSAutocompleteFilter()
        // MARK: Single Country Personalization
//        fetcherFilter.country = "IN" //(Locale.current.regionCode ?? "")
        fetcher?.autocompleteFilter = fetcherFilter
        
        if isFromPatientProfile {
            self.searchTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "search_your_location", Font: fontRegular16)
        }
        else {
            self.searchTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "search", Font: fontRegular16)
        }
        self.searchView.layer.borderWidth = 0.5
        self.searchView.layer.borderColor = (UIColor(named: "lineColor") ?? .white).cgColor
        self.searchView.viewRadius(radius:5)
        if !isFromHospital {
            self.searchView.isHidden = true
        }
        else {
            self.searchView.isHidden = false
        }
        self.loadData()
    }
    func loadData() {
        DispatchQueue.main.async {
            let viewModel = SettingViewModel()
            viewModel.adminlistingproperties { (success) in
                
            } onFailure: { (failure) in
                
            }
        }
    }
    @objc func barButtonAction(_ notification: Notification) {
        print(notification)
        if let isLeft = notification.userInfo?["isLeft"] as? Int {
            print(isLeft)
            if isLeft == 0 {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromHospital {
            return self.filterPlaces.count
        }
        return self.selectedHospital?.locations.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "SelectionTableViewCell") as! SelectionTableViewCell
        if isFromHospital {
            cell.titleLabel.text = self.filterPlaces[indexPath.row].attributedFullText.string
            if (self.selectedPrediction?.attributedFullText.string ?? "") == self.filterPlaces[indexPath.row].attributedFullText.string {
                cell.selectButton.setImage(#imageLiteral(resourceName: "Check_Sel"), for: .normal)
            }
            else {
                cell.selectButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
            }
        }
        else {
            cell.titleLabel.text = self.selectedHospital?.locations[indexPath.row].location ?? ""
            if let selectedLocation = self.selectedLocation, let currentLocation = self.selectedHospital?.locations[indexPath.row] {
                if selectedLocation.id == currentLocation.id {
                    cell.selectButton.setImage(#imageLiteral(resourceName: "Check_Sel"), for: .normal)
                }
                else {
                    cell.selectButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
                }
            }
            else {
                cell.selectButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isFromHospital {
            if let currentLocation = self.selectedHospital?.locations[indexPath.row] {
                if let selectedLocation = self.selectedLocation {
                    if selectedLocation.id == currentLocation.id {
                        self.selectedLocation = nil
                    }
                    else {
                        self.selectedLocation = currentLocation
                        self.tableView.reloadData()
                        self.delegate?.locationData(currentLocation)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                else {
                    self.selectedLocation = currentLocation
                    self.tableView.reloadData()
                    self.delegate?.locationData(currentLocation)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        else {
            let placeClient = GMSPlacesClient.shared()
            selectedPrediction = self.filterPlaces[indexPath.row]
            self.tableView.reloadData()
            placeClient.lookUpPlaceID(self.filterPlaces[indexPath.row].placeID) { (fields, error) in
                 if let error = error {
                   print("An error occurred: \(error.localizedDescription)")
                   return
                 }
                 if let place = fields {
                    print("The selected place is: \(place.addressComponents?.last?.shortName ?? "")")
                    self.delegate?.locationDetails(self.filterPlaces[indexPath.row].attributedFullText.string, lat: "\(place.coordinate.latitude)", long: "\(place.coordinate.longitude)", countryCode: ((place.addressComponents?.last?.shortName ?? (Locale.current.regionCode ?? "IN"))))
                    self.navigationController?.popViewController(animated: true)
                 }
            }
        }
    }
    
    @IBAction func searchAct(_ sender: UITextField) {
        if sender.text != "" {
            fetcher?.sourceTextHasChanged(sender.text!)
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji {
            return false
        }
        return true
    }
 }
 extension select_Location {
    func passLocation(_ location: String){
    }
    func getLocId (_ getLocationId : String){
        
    }
 }
 extension HospitalLocationPage: GMSAutocompleteFetcherDelegate {
    
    func didFailAutocompleteWithError(_ error: Error) {
        print("Did Fail Auto Complete With Error :\(error.localizedDescription)")
        
    }
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        self.filterPlaces.removeAll()
        self.filterPlaces = predictions
        self.tableView.reloadData()
    }
    
    func getPlaceDetails(_ placeID: String) {
        let placeClient = GMSPlacesClient.shared()
        placeClient.lookUpPlaceID(placeID) { (fields, error) in
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
            }
            if let place = fields {
                print("The selected place is: \(place.name)")
            }
        }
    }
 }
