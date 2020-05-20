//
//  HomeTabBarVC.swift
//  Davai
//
//  Created by Apple on 2/4/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import PKHUD
import SDWebImage
import CLabsImageSlider

class HomeTabBarVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viewSlider: CLabsImageSlider!
    @IBOutlet var viewSkip: GradientView!
    
    var arrayOfCategories :[Category]?
    var arrayOfAds :[Ads]?
    var arrayOfSliderImages :[String] = []
    var searchActive : Bool = false
    var filterArray : [Category]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
//        textFieldInsideSearchBar?.textColor = UIColor.black
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor(displayP3Red: 32/255, green: 60/255, blue: 82/255, alpha: 1)
        textFieldInsideSearchBar?.backgroundColor = UIColor.white
        textFieldInsideSearchBar?.placeholder = "Search"
        searchBar.setImage(UIImage(named: "mySearch"), for: .search, state: .normal)

        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 32/255, green: 60/255, blue: 82/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.lightGray]
        navigationItem.title = "Home"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        
        
        searchBar.delegate = self
        navigationItem.title = "homenav".localized
        if APPLANGUAGE == "en"{
            for subView in searchBar.subviews  {
                for subsubView in subView.subviews  {
                    if let textField = subsubView as? UITextField {
                        textField.attributedPlaceholder =  NSAttributedString(string:NSLocalizedString("SearchBar".localized, comment:""),
                                                                              attributes:[NSAttributedStringKey.foregroundColor: UIColor.gray])
                    }
                }
            }
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupViews()
        
        if CheckInternet.Connection(){
            HUD.show(.progress)
            WebService.instance.getCategories { (onSccuess, cateogries) in
                if onSccuess{
                    self.arrayOfCategories = cateogries
                    self.filterArray = cateogries
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
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Connection".localized))
        }
    }
    
    
    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            arrayOfCategories = filterArray;
            collectionView.reloadData()
            return
        }
        arrayOfCategories = filterArray?.filter({ (filter) -> Bool in
            return (filter.titleEN.contains(searchText.lowercased()))
        })
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        WebService.instance.getAds { (onSuccess, ads) in
            if onSuccess{
                self.arrayOfAds = ads
                for item in self.arrayOfAds!{
                    self.arrayOfSliderImages.append(item.imgPath)
                }
                
                self.viewSlider.setUpView(imageSource: .Url(imageArray:self.arrayOfSliderImages,placeHolderImage:UIImage(named:"Favorite")),slideType:.Automatic(timeIntervalinSeconds: 3.0),isArrowBtnEnabled: true)
                HUD.hide()
            }
        }
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    
    func setupViews(){
        
        searchBar.placeholder = "SearchBar".localized
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfCategories?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! homeCell
        
        cell.imageCell?.sd_setImage(with: URL(string: (arrayOfCategories?[indexPath.row].imgPath ?? "")), placeholderImage: UIImage(named: "AXP"))
        cell.nameLabel.text = arrayOfCategories?[indexPath.row].titleEN
        //cell.containerView.layer.cornerRadius = 30
        
        
        return cell
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
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PlacesVC") as! PlacesVC
        vc.categoryId = arrayOfCategories?[indexPath.row].categID
        vc.navTitle = arrayOfCategories?[indexPath.row].titleEN ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
}
