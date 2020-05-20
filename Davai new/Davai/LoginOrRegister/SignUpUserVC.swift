//
//  SignUpUserVC.swift
//  Davai
//
//  Created by MacBook  on 1/30/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import UICheckbox_Swift
import PKHUD

class SignUpUserVC: ViewController,SigningApiDelegate ,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{
    
    @IBOutlet weak var btnConditions: UIButton!
    @IBOutlet weak var cityTF: TextField!
    @IBOutlet weak var CountryTF: TextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var mobieTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var maleBtn: DLRadioButton!
    @IBOutlet weak var signInBtn: GradientButton!
    @IBOutlet weak var checkBtn: UICheckbox!
    
    var user :User?
    var termAccepted = false
    var gender :Int!
    //var Signing = SigningApi()
    var webService = WebService()
    var arrayOfCountries :[Country]?
    var arrayOfCities :[City]?
    var countrySelectedId :String?
    var citySelectedId :String?
    let pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserData()
        setuptextField()
        setPickerToField(pickerView :pickerView,textField: CountryTF, title: "Countries".localized)
        checkBtn.onSelectStateChanged = { (checkbox, selected) in
            self.termAccepted = true
            
        }
        //countryTF.delegate = self
        //Signing.delegate = self
        webService.delegate = self
        setUpViews()
        signInBtn.setTitle("signin".localized, for: .normal)
    }
    private func setUserData(){
        if Helper.getFromUserDefault(key: "email") != "" {
            emailTF.text = Helper.getFromUserDefault(key: "email")
        }
        if Helper.getFromUserDefault(key: "firstName") != "" {
           firstNameTF.text = Helper.getFromUserDefault(key: "firstName")
        }
        if Helper.getFromUserDefault(key: "lastName") != "" {
             lastNameTF.text = Helper.getFromUserDefault(key: "lastName")
        }
        
       
        
    }
    // MARK:- TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == CountryTF {
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
            if CountryTF.text == nil || CountryTF.text == ""{
                showDefaultAlert(with: "Dismiss".localized, message: "Selectyourcountry".localized)
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
    }
    // MARK:- setup PickerView
    private func setuptextField(){
    CountryTF.delegate = self
    cityTF.delegate = self
    }
   
    //MARK:- fill cities lst
    @IBAction func genderAction(_ sender: Any) {
        if((sender as AnyObject).tag == 1){
            print("Male")
            gender = 1
            
        }
        else {
            print("Female")
            gender = 0
        }
    }
    
    var phoneNumber: String?
    // MARK:- sign up action
    @IBAction func signUpPressed(_ sender: UIButton){
        var isEmail = false
        //var isPhone = false
        
        let Formatter = NumberFormatter()
        Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale!
        if let final = Formatter.number(from: mobieTF.text ?? "") {
            mobieTF.text = "0" + "\(final)"
            phoneNumber = "0" + "\(final)"
        }

        isEmail =  Validate.isValidEmail(testStr: emailTF.text ?? "")
        
        if let firstName = firstNameTF.text , let lastName = lastNameTF.text , let mobile = phoneNumber , let email = emailTF.text , let password = passwordTF.text  {
            if passwordTF.text == confirmPasswordTF.text  && firstNameTF.text != nil , lastNameTF.text != nil && emailTF.text != nil && emailTF.text != "" && mobieTF.text != nil && mobieTF.text != "" && passwordTF.text != nil && termAccepted == true && isEmail {

                let params = [
                    "firstName": firstName,
                    "lastName": lastName,
                    "mobile": mobile,
                    "email": email,
                    "password": password,
                    "countryID": "5c80198a3013bb3fc0a01ce9",
                    "cityID": "5c8019c63013bb3fc0a01cea",
                    "gender":1
                    ] as [String : Any]
                webService.signUp(params: params)
            }
                
            else if firstNameTF.text == nil || firstNameTF.text == ""{
              pushAlert(title: "ERROR".localized, message: "EnterFirstName".localized)
            }
            else if lastNameTF.text == nil || lastNameTF.text == ""{
                pushAlert(title: "ERROR".localized, message: "Enteryourlastname".localized)
            }
            else if !isEmail
            {
                    pushAlert(title:"ERROR".localized, message: "entervalidateemail".localized)
            }
          
            else  if mobieTF.text == nil || mobieTF.text == ""{
                pushAlert(title: "ERROR".localized, message: "Enterphonenumber".localized)
            }
            else  if emailTF.text == nil || emailTF.text == ""{
                pushAlert(title: "ERROR".localized, message: "Enteryouremail")
            }
//            else  if countrySelectedId == nil {
//                pushAlert(title: "ERROR".localized, message: "chooseCountry".localized)
//            }
//            else  if citySelectedId == nil {
//                pushAlert(title:"ERROR".localized, message: "chooseCity".localized)
//            }
             else if passwordTF.text == nil || passwordTF.text == ""{
                pushAlert(title: "ERROR".localized, message: "Enteryourpassword".localized)
            }
             else if confirmPasswordTF.text == nil || confirmPasswordTF.text == ""{
                pushAlert(title: "ERROR".localized, message: "ConfirmPassword".localized)
            }
             else if passwordTF.text !=  confirmPasswordTF.text {
                pushAlert(title: "ERROR".localized, message: "MatchPass".localized)
            }
             else if termAccepted == false{
                pushAlert(title: "ERROR".localized, message: "Checkterms".localized)
            }
//            else if gender == nil {
//                pushAlert(title: "ERROR".localized, message: "ChooseYourGender".localized)
//            }
        }
    }
    
    /// Func alertView
    func pushAlert(title :String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok".localized, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    // MARK:- getCoubtries func
    func setUpViews(){
        btnConditions.setTitle("AcceptTerms".localized, for: .normal)
        signInBtn.layer.borderWidth = 2
        signInBtn.layer.borderColor = UIColor.white.cgColor
        
        firstNameTF.layer.borderColor = UIColor.lightGray.cgColor
        firstNameTF.layer.borderWidth = 2
        firstNameTF.attributedPlaceholder = NSAttributedString(string: "fname".localized,
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        lastNameTF.layer.borderColor = UIColor.lightGray.cgColor
        lastNameTF.layer.borderWidth = 2
        lastNameTF.attributedPlaceholder = NSAttributedString(string: "LastName".localized,
                                                              attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        mobieTF.layer.borderColor = UIColor.lightGray.cgColor
        mobieTF.layer.borderWidth = 2
        mobieTF.attributedPlaceholder = NSAttributedString(string: "Mobile".localized,
                                                           attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        emailTF.layer.borderColor = UIColor.lightGray.cgColor
        emailTF.layer.borderWidth = 2
        emailTF.attributedPlaceholder = NSAttributedString(string: "Emailaddress".localized,
                                                           attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
                CountryTF.layer.borderColor = UIColor.lightGray.cgColor
                CountryTF.layer.borderWidth = 2
                CountryTF.attributedPlaceholder = NSAttributedString(string: "Countries".localized,
                                                                     attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
                cityTF.layer.borderColor = UIColor.lightGray.cgColor
                cityTF.layer.borderWidth = 2
                cityTF.attributedPlaceholder = NSAttributedString(string: "City".localized,
                                                                  attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        //
        passwordTF.layer.borderColor = UIColor.lightGray.cgColor
        passwordTF.layer.borderWidth = 2
        passwordTF.attributedPlaceholder = NSAttributedString(string: "Password".localized,
                                                              attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        confirmPasswordTF.layer.borderColor = UIColor.lightGray.cgColor
        confirmPasswordTF.layer.borderWidth = 2
        confirmPasswordTF.attributedPlaceholder = NSAttributedString(string: "ConfirmPassword".localized,
                                                                     attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let SignInVC = segue.destination as? SignInVC
        {
            if (segue.identifier == "userToSignIn") {
                SignInVC.emailStr = emailTF.text
            }
        }
    }
}
// extention SignUpUserVC
extension SignUpUserVC{
    func didSuccess(item: [String : Any]) {
        HUD.hide()
performSegue(withIdentifier: "userToSignIn", sender: nil)
    }
    
    func didFail(with error: String) {
        print("errorr \(error)")
        HUD.hide()
    }
    
}
// MARK:_  Fill PickerView
extension SignUpUserVC{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag ==  3{
            return (arrayOfCountries?.count) ?? 0
        }
        else if pickerView.tag == 4{
            return (arrayOfCities?.count) ?? 0
        }
        else {
            return 1
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag ==  3{
            if APPLANGUAGE == "en"{
                return arrayOfCountries?[row].titleEN
            }
            else {
                return arrayOfCountries?[row].titleAr
            }
        }
        else if pickerView.tag == 4{
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
        if pickerView.tag ==  3 {
            if APPLANGUAGE == "en"{
                CountryTF.text = arrayOfCountries?[row].titleEN
                countrySelectedId = arrayOfCountries?[row].countryID
                print("countryId \(countrySelectedId)")
            }
            else{
                CountryTF.text = arrayOfCountries?[row].titleAr
                countrySelectedId = arrayOfCountries?[row].countryID

                print("countryId \(countrySelectedId)")
            }
        }
        else if pickerView.tag == 4{
            if APPLANGUAGE == "en"{
                cityTF.text = arrayOfCities?[row].titleEN
                citySelectedId = arrayOfCities?[row].cityID

                print("cityId \(citySelectedId)")
            }
            else{
                cityTF.text = arrayOfCities?[row].titleAr
                citySelectedId = arrayOfCities?[row].cityID

                print("cityId \(citySelectedId)")
            }
        }
    }
}
