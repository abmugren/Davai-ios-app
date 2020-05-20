//
//  AboutPlaceVC.swift
//  Davai
//
//  Created by Apple on 2/5/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import PKHUD
import SDWebImage
import Cosmos
import Alamofire
class AboutPlaceVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @IBOutlet weak var btnUpdate: GradientButton!
    
    @IBOutlet weak var btnUpdateCover: UIButton!
    @IBOutlet weak var btnUpdateProfile: UIButton!
    @IBOutlet weak var lblNumberFavorites: UILabel!
    @IBOutlet weak var lblNumberRate: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var viewRate: CosmosView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var vendorCategoryBtn: UIButton!
    @IBOutlet weak var btnLiked: UIButton!
    
    @IBOutlet weak var txtDecription: UITextView!
    
    @IBOutlet weak var btnEDit: UIButton!
    @IBOutlet weak var btnRate: UIButton!
    @IBOutlet weak var lblEmail: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblVendorWebSite: UIButton!
    @IBOutlet weak var lblVendorLocation: UILabel!
    @IBOutlet weak var lblVendorCity: UILabel!
    @IBOutlet weak var lblVendorCountry: UILabel!
    @IBOutlet weak var lblPhone: UIButton!
    @IBOutlet weak var lblVendorName: UILabel!
    @IBOutlet weak var txtCall: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtWebsite: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    
    let clientCover = Helper.getFromUserDefault(key: "clientCover")
    let fromSideMenu = Helper.getFromUserDefault(key: "aboutPlace")
    let places = Helper.getFromUserDefault(key: "places")
    var placeId = Helper.getFromUserDefault(key: "placeId")
    let userId = Helper.getFromUserDefault(key: "userId")
    var clientId :String = Helper.getFromUserDefault(key: "clientId") ?? ""
    var userType :String = Helper.getFromUserDefault(key: "userType") ?? ""
    var client :ClientTest?
    var liked = false
    var arrayOfCountries :[Country]?
    var arrayOfCities :[City]?
    var countrySelectedId :String?
    var citySelectedId :String?
    let pickerView = UIPickerView()
    var imgLogoPath :String?
    var imgCoverPath :String?
    var vendorEmail :String?
    var vendorWebsite :String?
    var vendorPhone :String?
    var favId :String = ""
    var dic = [String:Any]()
    var btnTag = 0
    
    var favo: Fav?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkFav()
        viewRate.rating = 0.0
        if clientId == ""{
            //viewRate.isUserInteractionEnabled = false
        }
        if (self.fromSideMenu == "true") {
            //setuptextField()
        }
        
        pickerView.delegate = self
        if clientCover != "" && clientCover != nil {
            coverImage.sd_setImage(with: URL(string: clientCover!), placeholderImage: UIImage(named: "AXP"))
        }
            if CheckInternet.Connection(){
                HUD.show(.progress)
                viewRate.didFinishTouchingCosmos = didFinishTouchingCosmos
                WebService.instance.getTotalClinetFav(clientID: clientId) { (onSuccess, numOfFav) in
                    if onSuccess{
                        self.lblNumberFavorites.text = "\(numOfFav ?? 0)"
                        HUD.hide()
                    }
                    else{
                        HUD.hide()
                        HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened"))
                    }
                }
            }
            else{
                HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Connection".localized))
            }
            if CheckInternet.Connection(){
                //HUD.show(.progress)
                if userType == "user" || userType == "skip" || favId != ""{
                    if favId != "" {
                        placeId = favId
                    }
                    print(placeId)
                    WebService.instance.getClientVendorById(clientId: placeId ?? "") { (onSccuess, client) in
                        if onSccuess{
                            
                            
                            self.logoImage?.sd_setImage(with: URL(string: (client?.logo ?? "")), placeholderImage: UIImage(named: "AXP"), completed: nil)
                            self.coverImage?.sd_setImage(with: URL(string: (client?.cover ?? "")), placeholderImage: UIImage(named: "AXP"), completed: nil)
                            self.lblVendorName.text = client?.brandName
                            print("After Passing \(self.lblVendorCountry.text = client?.countryID?.titleEN)")
                           
                            
                            self.lblDescription.text = client?.description
                            self.lblPhone.setTitle(client?.VendorMobile, for: .normal)
                            self.lblVendorWebSite.setTitle(client?.website, for: .normal)
                            self.lblEmail.setTitle(client?.email, for: .normal)
                            self.vendorEmail = client?.email
                            self.vendorWebsite = client?.website
                            self.vendorPhone  = client?.VendorMobile
                            self.lblVendorLocation.text = client?.VendorAddress
                            if client?.totalRateD != nil{
                                print(client?.totalRateD)
                                self.lblNumberRate.text = "\(client?.totalRateD ?? 0.0)"
                                self.viewRate.rating = Double(client?.totalRateD ?? 0.0)
                            }
                            else{
                                print(client?.totalRateI)
                                self.lblNumberRate.text = "\(client?.totalRateI ?? 0)"
                                self.viewRate.rating = Double(client?.totalRateI ?? 0)
                            }
                            
                            if APPLANGUAGE == "en"{
                                self.lblVendorCountry.text = client?.countryTitleEn
                                self.lblVendorCity.text = client?.cityTitleEn
                            }
                            else {
                                self.lblVendorCountry.text = client?.countryTitleAr
                                self.lblVendorCity.text = client?.ccityTitleAr
                            }
                            HUD.hide()
                        }
                        else{
                            HUD.hide()
                            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened".localized))
                        }
                    }
                }
                else if userType == "vendor"{
                    let id :String?
                    if self.fromSideMenu == "true"{
                        id = clientId
                    }
                    else {
                        id = placeId
                    }
                    WebService.instance.getClientVendorById(clientId: id ?? "") { (onSccuess, client) in
                        if onSccuess{
                        
                            self.client = client
                    
//                            if client?.__v == 1{
//                                self.liked = true
//                                self.btnLiked.setImage(UIImage(named: "Favorite")?.withRenderingMode(.alwaysOriginal), for: .normal)
//                            }
//                            else{
//                                self.liked = false
//                                self.btnLiked.setImage(UIImage(named: "heart2")?.withRenderingMode(.alwaysOriginal), for: .normal)
//                            }
                            self.logoImage?.sd_setImage(with: URL(string: (client?.logo ?? "")), placeholderImage: UIImage(named: "AXP"), completed: nil)
                            self.coverImage?.sd_setImage(with: URL(string: (client?.cover ?? "")), placeholderImage: UIImage(named: "AXP"),completed: nil)
                            self.lblVendorName.text = client?.brandName
                            
                            self.lblDescription.text = client?.description
                            self.lblPhone.setTitle(client?.VendorMobile, for: .normal)
                            self.lblVendorWebSite.setTitle(client?.website, for: .normal)
                            self.lblEmail.setTitle(client?.email, for: .normal)
                            self.vendorEmail = client?.email
                            self.vendorWebsite = client?.website
                            self.vendorPhone  = client?.VendorMobile
                            self.lblVendorLocation.text = client?.VendorAddress
                            if client?.totalRateD != nil{
                                self.lblNumberRate.text = "\(client?.totalRateD ?? 0.0)"
                                self.viewRate.rating = Double(client?.totalRateD ?? 0.0)
                            }
                            else{
                                self.lblNumberRate.text = "\(client?.totalRateI ?? 0)"
                                self.viewRate.rating = Double(client?.totalRateI ?? 0)
                            }
                            if APPLANGUAGE == "en"{
                                self.lblVendorCountry.text = client?.countryTitleEn
                                self.lblVendorCity.text = client?.cityTitleEn
                            }
                            else {
                                self.lblVendorCountry.text = client?.countryTitleAr
                                self.lblVendorCity.text = client?.ccityTitleAr
                            }
//                            if self.fromSideMenu == "true"{
//                                self.txtCall.text = client?.VendorMobile
//                                if APPLANGUAGE == "en"{
//                                    self.txtCountry.text = client?.countryTitleEn
//                                    self.txtCity.text = client?.cityTitleEn
//                                }
//                                else {
//                                    self.txtCountry.text = client?.countryTitleAr
//                                    self.txtCity.text = client?.ccityTitleAr
//                                }
//                                self.txtWebsite.text = client?.website
//                                self.txtLocation.text = client?.VendorAddress
//                                self.txtEmail.text = client?.email
//                                self.txtDecription.text = client?.description
//                            }
                            
                            HUD.hide()
                        }
                        else{
                            HUD.hide()
                            HUD.flash(.labeledError(title:  "ERROR".localized, subtitle: "ErrorHappened"))
                        }
                    }
                }
            }
            else{
                HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Connection".localized))
        }
    }
    
    func checkFav(){
        Alamofire.request("http://104.248.175.110/api/user/checkOnFav?clientID=\(placeId ?? "")&userID=\(userId ?? "")", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            do {
                let test = try JSONDecoder().decode(Fav.self, from: response.data!)
                self.favo = test
                let checkk = self.favo?.message
                if (checkk == "favorite"){
                    self.liked = true
                    self.btnLiked.setImage(UIImage(named: "Favorite")?.withRenderingMode(.alwaysOriginal), for: .normal)
                }
                else {
                    self.liked = false
                    self.btnLiked.setImage(UIImage(named: "heart2")?.withRenderingMode(.alwaysOriginal), for: .normal)
                }
            }
            catch {
                print("error")
            }
           
        }
    }
    @IBAction func openWeb(_ sender: UIButton) {
        if let url = URL(string: "http://\(client?.website ?? "")") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    @IBAction func openEmail(_ sender: UIButton) {
        let email = client?.email ?? ""
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
    @IBAction func makeCallBtn(_ sender: UIButton) {
        guard let number = URL(string: "tel://" + (client?.VendorMobile ?? "")) else { return }
        UIApplication.shared.open(number)
    }
    
    
    
    
    private func didFinishTouchingCosmos(_ rating: Double) {
        if userType == "user"{
            if favId != "" {
                placeId = favId
            }
            let userId = Helper.getFromUserDefault(key: "userId")
            let params = ["clientID":placeId ?? "","userID":userId ?? "","rate":rating] as [String : Any]
            if CheckInternet.Connection(){
                HUD.show(.progress)
                WebService.instance.rateVendor(params: params) { (onSuccess, rate) in
                    if onSuccess{
                        self.viewRate.rating = Double(rate ?? 0)
                        HUD.hide()
                    }
                    else{
                        HUD.hide()
                        HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened".localized))
                    }
                }
            }
            else{
                HUD.flash(.labeledError(title:  "ERROR".localized, subtitle: "cConnection".localized))
            }
            viewRate.didFinishTouchingCosmos = didFinishTouchingCosmos
            setUpViews()
        }
        else {
             HUD.flash(.labeledError(title:  "ERROR".localized, subtitle: "clientCant".localized), delay: 1.5)
        }
       
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    ////
    @IBAction func btnUpdateCover(_ sender: Any) {
        
    }
    
    @IBAction func btnUpdateImg(_ sender: Any) {
        if (sender as AnyObject).tag == 1{
            btnTag = 1
        }
        else{
            btnTag = 2
        }
        let imagepickercontroller = UIImagePickerController()
        imagepickercontroller.delegate = self
        let actionsheet = UIAlertController(title: "Maxiumum".localized, message: "ChooseASource".localized, preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Camera".localized, style: .default, handler: { (action:UIAlertAction) in
            
            //
            imagepickercontroller.delegate = self
            imagepickercontroller.sourceType = .camera
           self.present(imagepickercontroller, animated: true, completion: nil)
        }))
        actionsheet.addAction(UIAlertAction(title: "Photolibrary".localized, style: .default, handler: { (action:UIAlertAction) in
            imagepickercontroller.sourceType = .photoLibrary
            self.present(imagepickercontroller, animated: true, completion: nil)
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        self.present(actionsheet, animated: true, completion: nil)
        
        
        
    }
    ////// MARK:- ImgPicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        WebService.instance.uploadThumbnail(thumbnail: image, completionHandler: { (sucess, response, error) in
            if sucess {
                if  self.btnTag == 1{
                    HUD.flash(.success, delay: 1.5)
                    self.imgCoverPath = response as? String
                }
                else if  self.btnTag == 2{
                    HUD.flash(.success, delay: 1.5)
                    self.imgLogoPath = response as? String
                }
            } else {
                print("error")
            }
        })
    }
    // MARK:- ImgPicker Cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnUpdateAll(_ sender: Any) {
        var isEmail = false
        var isWebsite = false
        var isPhone = false
        
        isEmail =  Validate.isValidEmail(testStr: txtEmail.text ?? "")
        isWebsite = Validate.verifyUrl(urlString: txtWebsite.text)
        isWebsite = Validate.verifyUrl(urlString: txtWebsite.text)
        isPhone = Validate.isValidatePhone(value: txtCall.text ?? "")
        
        if txtDecription.text == "" || txtDecription.text.count < 6 {
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "validDescription".localized), delay: 1.5)
        }
            
        else if txtLocation.text == "" {
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "validateLocation".localized), delay: 1.5)
        }
        else if self.txtCall.text == nil || self.txtCall.text == "" || !isPhone{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Entervalidphonenumber".localized), delay: 1.5)
        }
        else if self.txtCity.text == nil || self.txtCity.text == ""{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Selectyourcity".localized), delay: 1.5)
        }
            
        else if !isEmail{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "entervalidateemail".localized), delay: 1.5)
        }
        else if !isWebsite{
            HUD.flash(.labeledError(title: "ERROR", subtitle: "Enteryourwebsite".localized), delay: 1.5)
        }
            
        else if (self.txtCountry.text?.isEmpty)! || self.txtCountry.text == ""{
            HUD.flash(.labeledError(title:"ERROR", subtitle: "chooseCountry".localized), delay: 1.5)
        }
            
        else if (self.txtWebsite.text?.isEmpty)! || self.txtWebsite.text == ""{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Enteryourwebsite".localized), delay: 1.5)
        }
        else{
            
            
            if countrySelectedId != nil {
                dic["countryID"] = countrySelectedId
            }
            if citySelectedId != nil{
                dic["cityID"] = citySelectedId
            }
            if imgLogoPath != nil {
                dic["personalImg"] = imgLogoPath!
            }
            if imgCoverPath != nil {
                dic["personalImgCover"] = imgCoverPath!
            }
            dic["phone"] = txtCall.text
            dic["description"] = txtDecription.text
            dic["location"] = txtLocation.text
            dic["website"] = txtWebsite.text
            dic["email"] = txtEmail.text
            
            if CheckInternet.Connection(){
                HUD.show(.progress)
                WebService.instance.updateClient(params: dic, clientId: clientId) { (onSuccess, user) in
                    if onSuccess{
                        HUD.hide()
                        self.view.makeToast("sucessfully".localized, duration: 2.0, position: .center)
                        self.logoImage?.sd_setImage(with: URL(string: self.imgLogoPath ?? ""), placeholderImage: UIImage(named: "AXP"), completed: nil)
                        self.coverImage?.sd_setImage(with: URL(string: self.imgCoverPath ?? ""), placeholderImage: UIImage(named: "AXP"),completed: nil)
                    }
                    else{
                        HUD.hide()
                        HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHapened".localized))
                    }
                }
            }
            else{
                HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Connection".localized))
            }
        }
    }
    ////
    
    @IBAction func btnLikedPressed(_ sender: Any) {
        if userType == "user"{
            if favId != "" {
                placeId = favId
            }
            let userId = Helper.getFromUserDefault(key: "userId")
            let params = ["clientID":placeId ?? "" ,"userID":userId ??  ""] as [String : Any]
            
            if CheckInternet.Connection(){
                HUD.show(.progress)
                if !liked{
                    WebService.instance.addFav(params: params ) { (onSuccess, liked) in
                        if onSuccess{
                            if liked{
                                self.btnLiked.setImage(UIImage(named: "Favorite")?.withRenderingMode(.alwaysOriginal), for: .normal)
                                self.liked = true
                                HUD.hide()
                            }
                            
                        }
                        else{
                            HUD.hide()
                            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened".localized))
                            
                        }
                    }
                }
                else{ // It's already liked
                    WebService.instance.deleteFav(clientId: placeId ?? "", userId: userId ?? "") { (onSuccess) in
                        if onSuccess{
                            self.btnLiked.setImage(UIImage(named: "heart2")?.withRenderingMode(.alwaysOriginal), for: .normal)
                            self.liked = false
                            HUD.hide()
                        }
                        else{
                            HUD.hide()
                            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened".localized))
                        }
                    }
                }
                
            }
            else{
                HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Connection".localized))
            }
        }
        else{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "clientCant".localized))
        }
    }
    @IBAction func btnRatePressed(_ sender: Any) {
        
    }
    @IBAction func btnWebsitePressed(_ sender: Any) {
        
        let urlString = vendorWebsite ?? ""
        if let url = NSURL(string:urlString ){
            UIApplication.shared.openURL(url as URL)
        }
    }
    @IBAction func btnEditPressed(_ sender: Any) {
        if btnEDit.tag == 0 {
            txtCall.isHidden = false
            txtCity.isHidden = false
            txtEmail.isHidden = false
            txtCountry.isHidden = false
            txtWebsite.isHidden = false
            txtLocation.isHidden = false
            btnUpdate.isHidden = false
            txtDecription.isHidden = false
            btnUpdateCover.isHidden = false
            btnUpdateProfile.isHidden = false
            btnEDit.tag = 1
        }
        else{
            txtCall.isHidden = true
            txtCity.isHidden = true
            txtEmail.isHidden = true
            txtCountry.isHidden = true
            txtWebsite.isHidden = true
            txtLocation.isHidden = true
            btnUpdate.isHidden = true
            txtDecription.isHidden = true
            btnUpdateCover.isHidden = true
            btnUpdateProfile.isHidden = true
            
            btnEDit.tag = 0
        }
        
    }
    
    @IBAction func btnCallPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "tel://\(vendorPhone ?? "0")")! as URL)
        
    }
    @IBAction func btnEmailPressed(_ sender: Any) {
//        guard let url = URL(string: vendorEmail ?? "") else { return }
//        UIApplication.shared.open(url)
//
        let urlString = vendorEmail ?? "www.c.com"
        if let url = NSURL(string:urlString ){
            if #available(iOS 10, *) {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                
            } else {
                UIApplication.shared.openURL(url as URL)
            }
        }
        
    }
    func setUpViews(){
        coverImage.layer.cornerRadius = 10
        coverImage.layer.masksToBounds = true
        
        logoImage.layer.cornerRadius = 10
        logoImage.layer.masksToBounds = true
        
        vendorCategoryBtn.layer.borderWidth = 2
        vendorCategoryBtn.layer.borderColor = UIColor.lightGray.cgColor
        vendorCategoryBtn.setTitle("vendorCategory".localized, for: .normal)
        
    }
    //
    // MARK:- TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtCountry {
            setPickerToField(pickerView:pickerView ,textField: txtCountry, title: "Countries".localized)
            HUD.show(.progress)
            WebService.instance.getCountries { (onSuccess, countries) in
                if onSuccess {
                    
                    self.arrayOfCountries = countries
                    self.pickerView.reloadAllComponents()
                    HUD.hide()
                }
                else{
                    HUD.hide()
                }
            }
        }
        else if textField == txtCity {
            if countrySelectedId == nil || txtCountry.text == ""{
                HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "chooseCountry".localized))
            }
            else {
                setPickerToField(pickerView:pickerView ,textField: txtCity, title: "Cities".localized)
                HUD.show(.progress)
                WebService.instance.getCities(countryId: countrySelectedId!) { (onSuccess, cities) in
                    if onSuccess{
                        self.arrayOfCities = cities
                        self.pickerView.reloadAllComponents()
                        HUD.hide()
                    }
                    else{
                        HUD.hide()
                    }
                }
            }
        }
    }
    // MARK:- setup PickerView
    private func setuptextField(){
        setPickerToField(pickerView :pickerView,textField: txtCity, title: "Cities".localized)
        txtCountry.delegate = self
        txtCity.delegate = self
        setPickerToField(pickerView :pickerView,textField: txtCountry, title: "Countries".localized)
    }
    //
}
///
// MARK:_  Fill PickerView
extension AboutPlaceVC{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag ==  1{
            return (arrayOfCountries?.count) ?? 0
        }
        else if pickerView.tag == 2{
            return (arrayOfCities?.count) ?? 0
        }
        else {
            return 0
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag ==  1{
            if APPLANGUAGE == "en"{
                return arrayOfCountries?[row].titleEN
            }
            else {
                return arrayOfCountries?[row].titleAr
            }
            
        }
        else if pickerView.tag == 2{
            if APPLANGUAGE == "en"{
                 return arrayOfCities?[row].titleEN
            }
            else {
                 return arrayOfCities?[row].titleAr
            }
           
        }
        else {
            return "default"
        }
    }
    // didSelect
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag ==  1 {
            if APPLANGUAGE == "en"{
                txtCountry.text = arrayOfCountries?[row].titleEN
                HUD.show(.progress)
                WebService.instance.getCities(countryId: arrayOfCountries?[row].countryID ?? "") { (onSuccess, cities) in
                    if onSuccess{
                        self.txtCity.text = cities?[0].titleEN
                        HUD.hide()
                    }
                    else{
                        HUD.hide()
                    }
                }
            }
            else {
                txtCountry.text = arrayOfCountries?[row].titleAr
                HUD.show(.progress)
                WebService.instance.getCities(countryId: arrayOfCountries?[row].countryID ?? "") { (onSuccess, cities) in
                    if onSuccess{
                        self.txtCity.text = cities?[0].titleAr
                        HUD.hide()
                    }
                    else{
                        HUD.hide()
                    }
                }
            }
            countrySelectedId = arrayOfCountries?[row].countryID
        }
        else if pickerView.tag == 2{
            if APPLANGUAGE == "en"{
                txtCity.text = arrayOfCities?[row].titleEN
            }
            else {
                txtCity.text = arrayOfCities?[row].titleAr
            }
            
            citySelectedId = arrayOfCities?[row].cityID
        }
    }
}
