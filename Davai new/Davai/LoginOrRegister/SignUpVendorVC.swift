//
//  SignUpVendorVC.swift
//  Davai
//
//  Created by MacBook  on 1/30/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import PKHUD

class SignUpVendorVC: ViewController ,PassDatadDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UIPickerViewDelegate,UINavigationControllerDelegate, Servicess{
    
    
    
    @IBOutlet weak var vendorNameTF: UITextField!
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var countryTF: TextField!
    
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var categoryBtn: UIButton!
    
    @IBOutlet weak var serviceBtn: UIButton!
    @IBOutlet weak var daysTF: UITextField!
    @IBOutlet weak var hoursTF: UITextField!
    @IBOutlet weak var uploadLogoTF: UITextField!
    @IBOutlet weak var uploadCoverTF: UITextField!
    @IBOutlet weak var websiteTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var lblFrom: TextField!
    
    var timefrom :Int?
    var timeTo :Int?
    let timePickerView = UIDatePicker()
    var arrayOfCategories :[Category]?
    var arrayOfCountries :[Country]?
    var arrayOfCities :[City]?
    var arrayOfServices :[Service]?
    var selectedCategoryRow :Int?
    var countrySelectedId :String?
    var citySelectedId :String?
    var selectedDay:Int?
    let pickerView = UIPickerView()
    var image = UIImage()
    var imgData = Data()
    var imgLogoPath :String?
    var imgCoverPath :String?
    var textFieldTag :Int?
    var user :User?
    var dic = [String:Any]()
    var serviceDic = [String:Any]()
    var serviceList = [VendorService]()
    let arrDays = ["None","Satday","Sunday","Monday","Tuesday","Wendsday","Thursday","Friday"]
    let arrDaysArr = ["لا شيء","السبت","الأحد","الإثنين","الثلاثاء","الأربعاء","الخميس","الجمعة"]
//    var existingItems = dic["services"] as? [[String: Any]] ?? [[String: Any]]()
    
    var dicJson = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPickerToField(pickerView :pickerView,textField: countryTF, title: "Countries".localized)

        setUserData()
        setUpTextField()
        setUpView()
        nextBtn.setTitle("next".localized, for: .normal)
    }
    private func setUserData(){
        if Helper.getFromUserDefault(key: "email") != "" {
            emailTF.text = Helper.getFromUserDefault(key: "email")
        }
        if Helper.getFromUserDefault(key: "firstName") != "" && Helper.getFromUserDefault(key: "lastName") != ""{
            vendorNameTF.text = "\(Helper.getFromUserDefault(key: "firstName") ?? "") \((Helper.getFromUserDefault(key: "lastName")) ?? "")"
        }
    }
    // MARK:- TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == uploadCoverTF || textField == uploadLogoTF {
            return false
        }
        else{
            return true
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField == lblFrom{
            timePickerView.datePickerMode = .time
            setTimePickerToField(pickerView: timePickerView, textField: lblFrom, title: "Time".localized)
            let calendar = Calendar.current
            let comp = calendar.dateComponents([.hour, .minute], from: timePickerView.date)
            let hour = comp.hour
            let minute = comp.minute
            timefrom = hour ?? 0
                        lblFrom.text = "\(timefrom ?? 0)"
        }
        if textField == hoursTF{
            timePickerView.datePickerMode = .time
            setTimePickerToField(pickerView: timePickerView, textField: hoursTF, title: "Time".localized)
            let calendar = Calendar.current
            let comp = calendar.dateComponents([.hour, .minute], from: timePickerView.date)
            let hour = comp.hour
            let minute = comp.minute
            timeTo = hour ?? 0
                        hoursTF.text = "\(timeTo ?? 0)"
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        ///
        if textField == lblFrom{
            timePickerView.datePickerMode = .time
            setTimePickerToField(pickerView: timePickerView, textField: lblFrom, title: "Time".localized)
        }
        if textField == hoursTF{
            timePickerView.datePickerMode = .time
            setTimePickerToField(pickerView: timePickerView, textField: hoursTF, title: "Time".localized)
        }

        if textField == daysTF {
             setPickerToField(pickerView :pickerView,textField: daysTF, title: "SelectOfDay".localized)
        }
        ///
        else if textField == countryTF {
            showProgressIndicator()
            WebService.instance.getCountries { (onSuccess, countries) in
                if onSuccess {
                    self.arrayOfCountries = countries
                     self.pickerView.reloadAllComponents()
                    self.hideProgressIndicator()
                }
            }
        }
        else if textField == cityTF {
            if countryTF.text == nil || countryTF.text == ""{
                showDefaultAlert(with: "Dismiss".localized, message: "chooseCountry".localized)
            }
            else {
                setPickerToField(pickerView:pickerView ,textField: cityTF, title: "Cities".localized)
                showProgressIndicator()
                WebService.instance.getCities(countryId: countrySelectedId!) { (onSuccess, cities) in
                    self.arrayOfCities = cities
                    self.pickerView.reloadAllComponents()
                    self.hideProgressIndicator()
                }
            }
        }
        else if textField == uploadLogoTF || textField == uploadCoverTF {
             view.endEditing(true)
            if textField == uploadCoverTF {
                textFieldTag = 4
            }
            else if textField == uploadLogoTF {
                textFieldTag = 3
            }
            let imagepickercontroller = UIImagePickerController()
            imagepickercontroller.delegate = self
            let actionsheet = UIAlertController(title: "Maxiumum".localized, message: "ChooseASource".localized, preferredStyle: .actionSheet)
            actionsheet.addAction(UIAlertAction(title: "Camera".localized, style: .default, handler: { (action:UIAlertAction) in
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
    }
    ////// MARK:- ImgPicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        WebService.instance.uploadThumbnail(thumbnail: image, completionHandler: { (sucess, response, error) in
            if sucess {
                print(response)
                HUD.flash(.success, delay: 2.0)
                if self.textFieldTag == 3{
                    self.imgLogoPath = response as? String
                    print("imgPathLogo \(String(describing: self.imgLogoPath))")
                }
                else if self.textFieldTag == 4 {
                    self.imgCoverPath = response as? String
                    print("imgPathCover \(String(describing: self.imgCoverPath))")
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
    // MARK:- upload phote
   
    // MARK:- TextField setup
    private func setUpTextField(){
        countryTF.delegate = self
        cityTF.delegate = self
        uploadLogoTF.delegate = self
        uploadCoverTF.delegate = self
        hoursTF.delegate = self
        lblFrom.delegate = self
        daysTF.delegate = self
        
    }
    // MARK:- Performe Sigue
        
    ///
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let CategryDestinationVC = segue.destination as? PickerVC
        {
            if (segue.identifier == "category") {
                CategryDestinationVC.delegatee = self
                CategryDestinationVC.arrayOfCategories = arrayOfCategories
            }
        }
        if let ServiceDestinationVC = segue.destination as? ServicePickerVC
        {
            if (segue.identifier == "service") {
                //ServiceDestinationVC.delegate = self
                ServiceDestinationVC.arrayOfServices = arrayOfServices
                print("arrayOfServices",arrayOfServices)
            }
        }
        if let nextSignUp = segue.destination as? NextSignUpVC
        {
            if (segue.identifier == "test") {
                nextSignUp.dic = dic
            }
        }
        //test
    }
    
    var phoneNumber: String?
    
    // MARK:- Sign up Again
    @IBAction func signUpAgain(_ sender: Any) {
        var isPhone = false
        var daysIsInt = false
        var hoursIsInt = false
        var isWebsite = false
        
        
        isWebsite = Validate.verifyUrl(urlString: websiteTF.text ?? "")
        daysIsInt = Validate.verifyInt(testStr: daysTF.text ?? "")
        hoursIsInt = Validate.verifyInt(testStr: hoursTF.text ?? "")
        
        let Formatter = NumberFormatter()
        Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale!
        if let final = Formatter.number(from: numberTF.text ?? "") {
            numberTF.text = "0" + "\(final)"
            phoneNumber = "0" + "\(final)"
        }
       
         if self.vendorNameTF.text == nil || self.vendorNameTF.text == ""{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Entername".localized), delay: 1.5)
        }
        else if (self.numberTF.text?.isEmpty)! || self.numberTF.text == ""{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Enterphonenumber".localized), delay: 1.5)
        }
        else if (self.countryTF.text?.isEmpty)! || self.countryTF.text == ""{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Selectyourcountry".localized), delay: 1.5)
        }
        else if (self.cityTF.text?.isEmpty)! || self.cityTF.text == ""{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Selectyourcity".localized), delay: 1.5)
        }
        else if self.selectedCategoryRow == nil {
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Chooseacategory".localized), delay: 1.5)
        }
//        else if self.serviceList.count <= 0  {
//            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Addyourservicelist".localized), delay: 1.5)
//        }
            // shoud add service check not nil
            
        else if (self.daysTF.text?.isEmpty)! || self.daysTF.text == ""{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Selectyouroffday".localized), delay: 1.5)
        }
//        else if !daysIsInt{
//            HUD.flash(.labeledError(title: "Wrong", subtitle: "Enter valid number of days"), delay: 1.5)
//        }
        else if (self.hoursTF.text?.isEmpty)! || self.hoursTF.text == ""{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "pickyourtimeoff".localized), delay: 1.5)
        }
//        else if !hoursIsInt{
//            HUD.flash(.labeledError(title: "Wrong", subtitle: "Enter valid number of hours"), delay: 1.5)
//        }
        else if imgLogoPath == nil {
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Picklogophoto".localized), delay: 1.5)
        }
            
        else if imgCoverPath == nil {
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Pickcoverphoto".localized), delay: 1.5)
        }
        else if (self.websiteTF.text?.isEmpty)! || self.websiteTF.text == ""{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Enteryourwebsite".localized), delay: 1.5)
        }
//        else if !isWebsite{
//            HUD.flash(.labeledError(title: "Wrong", subtitle: "Enter valid website url "), delay: 1.5)
//        }
        else if (self.emailTF.text?.isEmpty)! || self.emailTF.text == ""{
            HUD.flash(.labeledError(title:"ERROR".localized, subtitle: "Enteryouremail".localized), delay: 1.5)
        }
        
        
        else{
           
            print(dicJson)
            dic["services"] = dicJson
            dic["brandName"] = self.vendorNameTF.text
            dic["VendorMobile"] = self.numberTF.text
            dic["offDay"] = selectedDay
            dic["from"] = timefrom
            dic["to"] = timeTo
            dic["VendorAddress"] = "test"
            dic["website"] = self.websiteTF.text
            dic["email"] = emailTF.text
            dic["countryID"] = countrySelectedId
            dic["cityID"] = citySelectedId
            dic["categoryID"] = arrayOfCategories?[selectedCategoryRow!].categID
            dic["cover"] = imgCoverPath
            dic["logo"] = imgLogoPath
            
            performSegue(withIdentifier: "test", sender: nil)
        }
       
    }
    
    @IBAction func countryPicker(_ sender: Any) {
        //performSegue(withIdentifier: "country", sender: nil)
    }
    @IBAction func categoryPicker(_ sender: Any) {
        showProgressIndicator()
        WebService.instance.getCategories { (onSuccess, categries) in
            if onSuccess{
                self.arrayOfCategories = categries
                self.performSegue(withIdentifier: "category", sender: nil)
                self.hideProgressIndicator()
            }
            else {
                self.hideProgressIndicator()
            }
        }
    }
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == uploadLogoTF {
//            return false; //do not show keyboard nor cursor
//        }
//        if textField == uploadCoverTF {
//            return false; //do not show keyboard nor cursor
//        }
//        return true
//    }
    
    @IBAction func serviceAction(_ sender: Any) {
        if selectedCategoryRow == nil {
            showDefaultAlert(with: "Dismiss".localized, message: "chooseCategory".localized)
        }
        else {
//            performSegue(withIdentifier: "service", sender: nil)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServicePickerVC") as! ServicePickerVC
            vc.myDelegate = self
            navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func setUpView(){
        nextBtn.layer.borderWidth = 2
        nextBtn.layer.borderColor = UIColor.white.cgColor
        
        vendorNameTF.layer.borderColor = UIColor.lightGray.cgColor
        vendorNameTF.layer.borderWidth = 2
        vendorNameTF.attributedPlaceholder = NSAttributedString(string: "VendorName".localized,
                                                                attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        numberTF.layer.borderColor = UIColor.lightGray.cgColor
        numberTF.layer.borderWidth = 2
        numberTF.attributedPlaceholder = NSAttributedString(string: "VendorPhoneNumber".localized,
                                                            attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        countryTF.layer.borderColor = UIColor.lightGray.cgColor
        countryTF.layer.borderWidth = 2
        countryTF.attributedPlaceholder = NSAttributedString(string: "Countries".localized,
                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        cityTF.layer.borderColor = UIColor.lightGray.cgColor
        cityTF.layer.borderWidth = 2
        cityTF.attributedPlaceholder = NSAttributedString(string: "City".localized,
                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        
        categoryBtn
            .layer.borderColor = UIColor.lightGray.cgColor
        categoryBtn.layer.borderWidth = 2
        categoryBtn.setTitle("Category".localized, for: .normal)
        categoryBtn.titleLabel?.textColor = UIColor.lightGray
        categoryBtn.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
        
        serviceBtn
            .layer.borderColor = UIColor.lightGray.cgColor
        serviceBtn.layer.borderWidth = 2
        serviceBtn.setTitle("Services".localized, for: .normal)
        serviceBtn.titleLabel?.textColor = UIColor.lightGray
        serviceBtn.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
        
        daysTF.layer.borderColor = UIColor.lightGray.cgColor
        daysTF.layer.borderWidth = 2
        daysTF.attributedPlaceholder = NSAttributedString(string: "offDay".localized,
                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        hoursTF.layer.borderColor = UIColor.lightGray.cgColor
        hoursTF.layer.borderWidth = 2
        hoursTF.attributedPlaceholder = NSAttributedString(string: "To".localized,
                                                           attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        lblFrom.layer.borderColor = UIColor.lightGray.cgColor
        lblFrom.layer.borderWidth = 2
        lblFrom.attributedPlaceholder = NSAttributedString(string: "From".localized,
                                                           attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        uploadLogoTF.layer.borderColor = UIColor.lightGray.cgColor
        uploadLogoTF.layer.borderWidth = 2
        uploadLogoTF.attributedPlaceholder = NSAttributedString(string: "UploadLogo".localized,
                                                                attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        uploadCoverTF.layer.borderColor = UIColor.lightGray.cgColor
        uploadCoverTF.layer.borderWidth = 2
        uploadCoverTF.attributedPlaceholder = NSAttributedString(string: "downloadcover".localized,
                                                                 attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        websiteTF.layer.borderColor = UIColor.lightGray.cgColor
        websiteTF.layer.borderWidth = 2
        websiteTF.attributedPlaceholder = NSAttributedString(string: "VendorWebsite".localized,
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        emailTF.layer.borderColor = UIColor.lightGray.cgColor
        emailTF.layer.borderWidth = 2
        emailTF.attributedPlaceholder = NSAttributedString(string: "VendorEmailAddress".localized,
                                                           attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
    }
}

// MARK:- Extenion
extension SignUpVendorVC{
    func userDidEnterInformation(row: Int) {
        selectedCategoryRow = row
        categoryBtn.setTitle(arrayOfCategories?[row].titleEN, for: .normal)
        
        WebService.instance.getServices(categoryId: (arrayOfCategories?[row].categID)!) { (onSuccess, services) in
            if onSuccess{
                self.arrayOfServices = services
                print("1",self.arrayOfServices)
                print("counttt \(String(describing: self.arrayOfServices?.count))")
            }
            else {
                print("erororr")
            }
        }
    }
    
    func didtappedOnService(id: String, price: Int, employees: [String]) {
        dicJson = [[
            "serviceID": id,
            "price": price,
            "emp": employees
            ]]
    }
    //
    func userDidAddedInformation(list: [VendorService]) {
        var dicObj = [String:Any]()
        
        
        
        
        serviceList = list
        print(serviceList)
        for service in serviceList{
           var dicObj = [String:Any]()
            let item: [String: Any] = [
                "servicesID": "uasdhuwdnkqjnds",
                "price": 50,
                "emp": ["aasd", "sadasd", "sdasd"]
            ]
           dicJson.append(item)
        }
       //
//        var dicObj = [String:Any]()
//        let item: [String: Any] = [
//            "servicesID": service.servicesID ?? "",
//            "price": service.price ?? 1,
//            "emp": service.emp!
//        ]
//        let str  = "{servicesID:\(service.servicesID ?? ""),price:\(service.price ?? 1),emp:\(service.emp!)}"
//        if postString != "[" {
//            postString = "\(postString ?? ""),\(str)"
//        }
//        else {
//            postString = "\(postString ?? "")\(str)"
//        }
//        dicJson.append(item)
//    }
//    postString = "\(postString)]"
    }
    // End of the class
}
// MARK:_  Fill PickerView
extension SignUpVendorVC{
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

        else if pickerView.tag == 10{
            return (arrDays.count)
        }
        else {
            return 1
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
        else if pickerView.tag == 10{
            if APPLANGUAGE == "en"{
                return arrDays[row]
            }
            else {
                return arrDaysArr[row]
            }
        }
        else {
           return ""
        }
    }
    // didSelect
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag ==  1 {
            if APPLANGUAGE == "en"{
                countryTF.text = arrayOfCountries?[row].titleEN
            }
            else {
                countryTF.text = arrayOfCountries?[row].titleAr
            }
            countrySelectedId = arrayOfCountries?[row].countryID
        }
        else if pickerView.tag == 2{
            if APPLANGUAGE == "en"{
                cityTF.text = arrayOfCities?[row].titleEN
            }
            else {
                cityTF.text = arrayOfCities?[row].titleAr
            }
            citySelectedId = arrayOfCities?[row].cityID
        }
        else if pickerView.tag == 10{
            if APPLANGUAGE == "en"{
                daysTF.text = arrDays[row]
            }
            else {
                daysTF.text = arrDaysArr[row]
               // selectedDay = row + 1
            }
            if row == 0 {
                selectedDay = row
            }
            else if row == 1{
                selectedDay = 7
            }
            else {
                selectedDay = row - 1
            }
            
        }
    }
}
//
