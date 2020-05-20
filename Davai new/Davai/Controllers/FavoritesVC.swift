//
//  FavoritesVC.swift
//  Davai
//
//  Created by Apple on 2/12/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import CLabsImageSlider
import PKHUD

class FavoritesVC: ViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet var viewNotAllowable: GradientView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewSlider: CLabsImageSlider!
    
    var arrayOfSearchItems :[String]?
    var searchActive : Bool = false
    var filterArray : [Favorite] = []
    var arrayOfAds :[Ads]?
    var arrayOfUserFavorite :[Favorite]?
    var selectedId :String?
    var arrayOfSliderImages :[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 32/255, green: 60/255, blue: 82/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.lightGray]
        if Helper.getFromUserDefault(key: "userType") == "user"{
            getFavorite()
        }
        else if Helper.getFromUserDefault(key: "userType") == "skip"{
            if APPLANGUAGE == "en"{
                showDefaultAlert(with: "ERROR".localized, message: "you should sign in as a user")
            }
            else{
                 showDefaultAlert(with:"ERROR".localized, message: "يجب عليك تسجيل الدخول كمستخدم")
            }
        }
        else if Helper.getFromUserDefault(key: "userType") == "vendor"{
            if APPLANGUAGE == "en"{
                showDefaultAlert(with: "ERROR".localized, message: "vendor hasn't favortie list")
            }
            else{
                showDefaultAlert(with:"ERROR".localized, message:  "العميل ليس لديه العناصر المفضلة")
            }
        }
        searchBar.delegate = self
        navigationItem.title = "Favorite".localized

       // setupView()
    }
    private func getFavorite(){
        if CheckInternet.Connection(){
            //HUD.show(.progress)
            let userId = Helper.getFromUserDefault(key: "userId")
            WebService.instance.getUserFavorite(userId: userId ?? "") { (onSuccess, favorites) in
                if onSuccess{
                    self.arrayOfUserFavorite = favorites
                    self.collectionView.reloadData()
                    HUD.hide()
                }
                else{
                   HUD.hide()
                }
            }
        }
        else{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Connection".localized))
        }
    }
    //
    
    //
    override func viewDidLayoutSubviews() {
        if CheckInternet.Connection(){
            //HUD.show(.progress)
            WebService.instance.getAds { (onSuccess, ads) in
                if onSuccess{
                    self.arrayOfAds = ads
                    for item in self.arrayOfAds!{
                        self.arrayOfSliderImages.append(item.imgPath)
                    }
                    self.viewSlider.setUpView(imageSource: .Url(imageArray:self.arrayOfSliderImages,placeHolderImage:UIImage(named:"Favorite")),slideType:.Automatic(timeIntervalinSeconds: 2.0),isArrowBtnEnabled: true)
                    //HUD.hide()
                }
                else{
                    //HUD.hide()
                }
            }
        }
        else{
            HUD.flash(.labeledError(title:"ERROR".localized, subtitle: "Connection".localized))
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        getFavorite()
    }
    // MARK:- Performe Sigue
    
    ///
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let aboutPlaceVC = segue.destination as? AboutPlaceVC
        {
            if (segue.identifier == "FavToAboutPlaces") {
                aboutPlaceVC.favId = selectedId ?? ""
            }
        }
       
    }
    //
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(searchActive) {
            return filterArray.count
        }
        else{
            return arrayOfUserFavorite?.count ?? 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! placesCell
        
        cell.imageCell.layer.cornerRadius = 25
        cell.imageCell.layer.masksToBounds = true
        cell.imageCell.layer.borderWidth = 2
        cell.imageCell.layer.borderColor = UIColor.lightGray.cgColor
        
       cell.btnRemovePref.isHidden = false
        cell.btnRemovePref.addTarget(self,action:#selector(removeFav(sender:)),for: .touchUpInside)
        if(searchActive){
            cell.btnRemovePref.tag = indexPath.row
            cell.imageCell?.sd_setImage(with: URL(string: (filterArray[indexPath.row].clientID.logo ?? "")), placeholderImage: UIImage(named: "AXP"))
            cell.numberLabel.text = "\(filterArray[indexPath.row].clientID.totalRate  ?? 0.0)"
            cell.lblName.text = filterArray[indexPath.row].clientID.brandName
            print("")
        }
        else {
             cell.btnRemovePref.tag = indexPath.row
                    let obj = arrayOfUserFavorite?[indexPath.row]
                    cell.imageCell?.sd_setImage(with: URL(string:obj?.clientID.logo ?? "" ), placeholderImage: UIImage(named: "AXP"))
                    cell.lblName.text = obj?.clientID.brandName
                    cell.numberLabel.text = "\(obj?.clientID.totalRate ?? 0.0)"
          
        }

        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         Helper.removeInUserDefault(key: "aboutPlace")
        selectedId = arrayOfUserFavorite?[indexPath.row].clientID._id
        performSegue(withIdentifier: "FavToAboutPlaces", sender: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  5
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    @objc func removeFav(sender:UIButton){
        let userId = Helper.getFromUserDefault(key: "userId")
        var clientId :String = ""
        if searchActive{
            clientId = filterArray[sender.tag].clientID._id ?? ""
        }
        else{
            clientId = arrayOfUserFavorite?[sender.tag].clientID._id ?? ""
        }
        WebService.instance.deleteFav(clientId: clientId , userId: userId ?? "") { (onSuccess) in
            if onSuccess{
                self.getFavorite()
                self.collectionView.reloadData()
            //HUD.hide()
            }
            else{
            HUD.hide()
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened"))
            }
            }
    }

}

//MARK:- Extenion SearchBar
extension FavoritesVC :UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        searchBar.showsCancelButton = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    //
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        if searchText == ""{
            self.searchActive = false
            collectionView.reloadData()
        }
        else{
            self.filterArray = (self.arrayOfUserFavorite?.filter { ($0.clientID.brandName?.contains(searchText))! })!
            self.searchActive = true
            collectionView.reloadData()
        }
        
    }
}
