//
//  PlacesVC.swift
//  Davai
//
//  Created by Apple on 2/4/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import PKHUD

class PlacesVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    // MARK:- variable
    
    var categoryId :String?
    var arrayOfClients :[VendorClientt]?
    var filterArray: [VendorClientt]?
    var searchActive : Bool = false
    var filterActive : Bool = false

    var filterAllArray :[String] = []
    
    var navTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = navTitle
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.black
        textFieldInsideSearchBar?.placeholder = "Search"

        setupSearchBar()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        filterAllArray.append("AllCities".localized)
        
        if CheckInternet.Connection(){
            //HUD.show(.progress)
            WebService.instance.getClientByCateogryID(categoryId: categoryId ?? "") { (onSuccess, clients) in
                if onSuccess{
                    
                    self.arrayOfClients = clients
                    self.filterArray = clients
                    self.collectionView.reloadData()
                    HUD.hide()
                }
                else{
                    HUD.hide()
                    HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened".localized))
                }
            }
        }
        else{
            HUD.hide()
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Connection".localized))
        }
        
    }
    
    func setupSearchBar(){
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            arrayOfClients = filterArray;
            collectionView.reloadData()
            return
        }
        arrayOfClients = filterArray?.filter({ (filter) -> Bool in
            return (filter.brandName!.contains(searchText.lowercased()))
        })
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let placeDetalVC = segue.destination as? PlaceDetailsVC
        {
            if (segue.identifier == "details") {
                placeDetalVC.fromPlaces = true
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return arrayOfClients?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! placesCell
        
            cell.imageCell?.sd_setImage(with: URL(string: (arrayOfClients?[indexPath.row].logo ?? "")), placeholderImage: UIImage(named: "AXP"), options: .scaleDownLargeImages, completed: nil)
            cell.lblName.text = arrayOfClients?[indexPath.row].brandName
        
        cell.imageCell.layer.cornerRadius = 25
        cell.imageCell.layer.masksToBounds = true
        cell.imageCell.layer.borderWidth = 1
        cell.imageCell.layer.borderColor = UIColor.white.cgColor
        
//        cell.numberLabel.text = "\(arrayOfClients?[indexPath.row].totalRate ?? 0.0)"
        cell.numberLabel.text = String(format: "%.0f", arrayOfClients?[indexPath.row].totalRate ?? 0.0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  5
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    //Space between items in the same row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Helper.removeInUserDefault(key: "aboutPlace")
        if searchActive
        {
            UserDefaults.standard.set("true", forKey: "places")
        }
        else {
            UserDefaults.standard.set("true", forKey: "places")
            UserDefaults.standard.set(arrayOfClients?[indexPath.row]._id, forKey: "placeId")
        }
        performSegue(withIdentifier: "details", sender: nil)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
