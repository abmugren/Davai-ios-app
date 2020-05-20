//
//  ReservationVC.swift
//  Davai
//
//  Created by Apple on 2/10/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import PKHUD
import DropdownButton
import Alamofire



class ReservationVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout ,UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    

    @IBOutlet weak var btnMyReservation: UIButton!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var filterStack: UIStackView!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var reserveBtn: GradientButton!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    
    @IBOutlet weak var viewfilter: UIView!
    
    
    
    
    let userName = Helper.getFromUserDefault(key: "userName")
    let countryId = Helper.getFromUserDefault(key: "countryId")
    let userType = Helper.getFromUserDefault(key: "userType")
    var check: Bool = true
    var searchActive : Bool = false
    var filterActive : Bool = false
    var filterCityActive : Bool = false
    var filterArray : [VendorClientt] = []
    var arrFilter : [VendorClientt] = []
    var arrCityFilter : [VendorClientt] = []
    let timePickerView = UIDatePicker()
    var time :String?
    var date :String?
    var arrayOfClients :[VendorClientt]?
    var arrayOfCateogry :[String] = ["AllCategory".localized]
    var arrayOfcityNames :[String] = ["AllCities".localized]
    
    var categoryArray: [Category]?
    var cityArray: [City]?
    
    private var selectedClientId :String?
    
    var categoryPicker = UIPickerView()
    var cityPicker = UIPickerView()
    
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getCountries()
        getCities()
        
        
        countryTF.layer.borderWidth = 1
        countryTF.layer.cornerRadius = 10
        countryTF.layer.borderColor = UIColor.white.cgColor
        countryTF.attributedPlaceholder = NSAttributedString(string: "Category".localized,
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        cityTF.layer.borderWidth = 1
        cityTF.layer.cornerRadius = 10
        cityTF.layer.borderColor = UIColor.white.cgColor
        cityTF.attributedPlaceholder = NSAttributedString(string: "City".localized,
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 32/255, green: 60/255, blue: 82/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.lightGray]
        btnMyReservation.setTitle("myReservation".localized, for: .normal)
        reserveBtn.setTitle("Reserve".localized, for: .normal)
        
        
        
        dateTF.attributedPlaceholder = NSAttributedString(string: "pickDate".localized,
        attributes: [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 32/255, green: 60/255, blue: 82/255, alpha: 1)])
        
        timeTF.attributedPlaceholder = NSAttributedString(string: "pickTime".localized,
        attributes: [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 32/255, green: 60/255, blue: 82/255, alpha: 1)])
        
        
        viewfilter.isUserInteractionEnabled = false
       
        
        if userType == "user" && APPLANGUAGE == "en"{
            lblUser.text = "Hi \(userName ?? "")"
        }
        else if userType == "user" && APPLANGUAGE == "ar"{
            lblUser.text = "مرحبا \(userName ?? "")"
        }
        else if userType == "skip" && APPLANGUAGE == "ar"{
            lblUser.text = "مرحبا"
        }
        else if userType == "vendor" && APPLANGUAGE == "ar"{
           lblUser.text = "مرحبا \(userName ?? "")"
        }
        else if userType == "vendor" && APPLANGUAGE == "en"{
            lblUser.text = "Hi \(userName ?? "")"
        }
        
        searchBar.delegate = self
        timeTF.delegate = self
        dateTF.delegate = self

        WebService.instance.getClientts { (onSuccess, clients) in
            if onSuccess{
                self.arrayOfClients = clients
                print(self.arrayOfClients)
                self.collectionView.reloadData()
            }
        }
        setupView()
        searchBar.backgroundImage = UIImage()
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor(displayP3Red: 32/255, green: 60/255, blue: 82/255, alpha: 1)
        textFieldInsideSearchBar?.backgroundColor = UIColor.white
        textFieldInsideSearchBar?.placeholder = "Search"
        searchBar.setImage(UIImage(named: "mySearch"), for: .search, state: .normal)

        
        countryTF.inputView = categoryPicker
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        cityTF.inputView = cityPicker
        cityPicker.delegate = self
        cityPicker.dataSource = self
        
        showDatePicker()
        showTimePicker()
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    //TIMEPICKER
    func showTimePicker(){
       //Formate Date
        timePicker.datePickerMode = .time
        //ToolBar
       let toolbar = UIToolbar();
       toolbar.sizeToFit()

       //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .bordered, target: self, action: #selector(doneTimePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: #selector(cancelDatePicker))
       toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

    // add toolbar to textField
    timeTF.inputAccessoryView = toolbar
     // add datepicker to textField
    timeTF.inputView = timePicker

       }
    
    @objc func doneTimePicker(){
     //For date formate
      let formatter = DateFormatter()
      formatter.dateFormat = "hh:mm"
//        formatter.amSymbol = "AM"
//        formatter.pmSymbol = "PM"
      timeTF.text = formatter.string(from: timePicker.date)
        time = timeTF.text
        
      //dismiss date picker dialog
      self.view.endEditing(true)
    }
    
    ///DatePicker
    func showDatePicker(){
       //Formate Date
        datePicker.datePickerMode = .date

        //ToolBar
       let toolbar = UIToolbar();
       toolbar.sizeToFit()

       //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: #selector(cancelDatePicker))
       toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

    // add toolbar to textField
    dateTF.inputAccessoryView = toolbar
     // add datepicker to textField
    dateTF.inputView = datePicker

       }
    
    @objc func donedatePicker(){
     //For date formate
      let formatter = DateFormatter()
      formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "en_US")
      dateTF.text = formatter.string(from: datePicker.date)
    date = dateTF.text
        
      //dismiss date picker dialog
      self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
     //cancel button dismiss datepicker dialog
      self.view.endEditing(true)
    }
    
    
    func getCountries (){
        WebService.instance.getCategories { (onSuccess, categries) in
            if onSuccess{
                self.categoryArray = categries
            }
        }
    }
    
    func getCities(){
        WebService.instance.getCities(countryId: countryId ?? "") { (onSuccess, cities) in
            self.cityArray = cities
            print(self.cityArray)
        }
    }
    
    func filtercategory(categoryID: String){
        let param = [
            "categoryID": categoryID
        ]
        Alamofire.request(Constant.get_categories, method: .get, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            self.arrayOfClients?.shuffle()
            self.collectionView.reloadData()
        }
    }
    //PICKERVIEW
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPicker {
            return categoryArray?.count ?? 0
        }
        else {
            return cityArray?.count ?? 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPicker {
            return APPLANGUAGE == "en" ? categoryArray?[row].titleEN : categoryArray?[row].titleAr
        }
        else {
            return APPLANGUAGE == "en" ? cityArray?[row].titleEN : cityArray?[row].titleAr
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPicker {
            
            countryTF.text = APPLANGUAGE == "en" ? categoryArray?[row].titleEN :
            categoryArray?[row].titleAr
            filtercategory(categoryID: categoryArray?[row].categID ?? "")
        }
        else {
            cityTF.text = APPLANGUAGE == "en" ? cityArray?[row].titleEN :  cityArray?[row].titleAr
            filtercategory(categoryID: cityArray?[row].cityID ?? "")
        }
    }
    
    //
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == dateTF{
//            dateTF.text = date
//        }
//        else if textField == timeTF{
//            timeTF.text = time
//        }
//    }
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == dateTF{
//            timePickerView.datePickerMode = .date
//            setTimePickerToField(pickerView: timePickerView, textField: dateTF, title: "Date".localized)
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "dd MMMM yyyy"
//            let selectedDate = dateFormatter.string(from: timePickerView.date)
//            print(selectedDate)
//            date = selectedDate
//        }
//        else if textField == timeTF{
//            timePickerView.datePickerMode = .time
//            setTimePickerToField(pickerView: timePickerView, textField: timeTF, title: "Time".localized)
//            let calendar = Calendar.current
//            let comp = calendar.dateComponents([.hour, .minute], from: timePickerView.date)
//            let hour = comp.hour
//            let minute = comp.minute
//            time = "\(hour ?? 0):\(minute ?? 0)"
//        }
//    }
    //
    @IBAction func filterAction(_ sender: Any) {
        if(check == true){
            filterStack.isHidden = false
            stackHeight.constant = 30
            check = false
        }
        else {
            filterStack.isHidden = true
            stackHeight.constant = 0
            check = true
        }
    }
    @IBAction func myReservations(_ sender: Any) {
        performSegue(withIdentifier: "userOrders", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let TabReservationVC = segue.destination as? TabReservationVC
        {
            if (segue.identifier == "TabReservationVC") {
                TabReservationVC.date = dateTF.text
                TabReservationVC.time = timeTF.text
                TabReservationVC.clientId = selectedClientId
            }
        }
    }
    
    @IBAction func btnReserve(_ sender: Any) {
        if dateTF.text == ""{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "DateValidate".localized), delay: 2.0)
        }
        else if timeTF.text == ""{
            HUD.flash(.labeledError(title:"ERROR".localized, subtitle: "TimeValidate".localized), delay: 2.0)
        }
        else{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle:"ItemValidate".localized), delay: 2.5)
            //performSegue(withIdentifier: "TabReservationVC", sender: nil)
        }
        
    }
    
    func setupView(){

        
        searchBar.barTintColor = UIColor.green
        searchBar.placeholder = "Search".localized
        searchBar.layer.cornerRadius = 15
        searchBar.clipsToBounds = true 
        
        dateView.layer.cornerRadius = 15
        dateView.layer.borderWidth = 2
        dateView.layer.borderColor = UIColor(displayP3Red: 30/255, green: 87/255, blue: 118/255, alpha: 1).cgColor
        
        timeView.layer.cornerRadius = 15
        timeView.layer.borderWidth = 2
        timeView.layer.borderColor = UIColor(displayP3Red: 30/255, green: 87/255, blue: 118/255, alpha: 1).cgColor
        
        
        navigationItem.title = "NewReservation".localized
        view.ashrafGradient(colorOne: UIColor(displayP3Red: 11/255, green: 36/255, blue: 71/255, alpha: 1) , colorTwo: UIColor(displayP3Red: 30/255, green: 87/255, blue: 118/255, alpha: 1))

        reserveBtn.layer.borderWidth = 2
        reserveBtn.layer.borderColor = UIColor.white.cgColor
        stackHeight.constant = 0
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(searchActive) {
            return filterArray.count
        }
        else if filterActive == true{
            return arrFilter.count
        }
        else if filterCityActive{
            return arrCityFilter.count
        }
        else{
            return arrayOfClients?.count ?? 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! placesCell
        cell.imageCell.layer.cornerRadius = 25
        cell.imageCell.layer.masksToBounds = true
        cell.imageCell.layer.borderWidth = 2
        cell.imageCell.layer.borderColor = UIColor.lightGray.cgColor
        if APPLANGUAGE == "en"{
            if(searchActive){
                
                cell.imageCell?.sd_setImage(with: URL(string: (filterArray[indexPath.row].logo ?? "")), placeholderImage: UIImage(named: "AXP"))
                cell.numberLabel.text = String(format: "%.0f", filterArray[indexPath.row].totalRate ?? 0.0)
                cell.lblName.text = filterArray[indexPath.row].brandName
                print("")
            }
            else if filterActive {
                cell.imageCell?.sd_setImage(with: URL(string: (arrFilter[indexPath.row].logo ?? "")), placeholderImage: UIImage(named: "AXP"))
                cell.numberLabel.text = String(format: "%.0f", filterArray[indexPath.row].totalRate ?? 0.0)
                cell.lblName.text = arrFilter[indexPath.row].brandName
            }
            else if filterCityActive{
                cell.imageCell?.sd_setImage(with: URL(string: (arrCityFilter[indexPath.row].logo ?? "")), placeholderImage: UIImage(named: "AXP"))
                cell.numberLabel.text = String(format: "%.0f", filterArray[indexPath.row].totalRate ?? 0.0)
                cell.lblName.text = arrCityFilter[indexPath.row].brandName
            }
            else{
                let obj = arrayOfClients?[indexPath.row]
                cell.imageCell?.sd_setImage(with: URL(string: obj?.logo ?? ""), placeholderImage: UIImage(named: "AXP"))
                cell.lblName.text = obj?.brandName
                cell.numberLabel.text = String(format: "%.0f", obj?.totalRate ?? 0.0)
            }
        }
        else{
            if(searchActive){
                
                cell.imageCell?.sd_setImage(with: URL(string: (filterArray[indexPath.row].logo ?? "")), placeholderImage: UIImage(named: "AXP"))
                cell.numberLabel.text = "\(filterArray[indexPath.row].totalRate  ?? 0.0)"
                cell.lblName.text = filterArray[indexPath.row].brandName
                print("")
            }
            else if filterActive {
                cell.imageCell?.sd_setImage(with: URL(string: (arrFilter[indexPath.row].logo ?? "")), placeholderImage: UIImage(named: "AXP"))
                cell.numberLabel.text = "\(arrFilter[indexPath.row].totalRate  ?? 0.0)"
                cell.lblName.text = arrFilter[indexPath.row].brandName
            }
            else if filterCityActive{
                cell.imageCell?.sd_setImage(with: URL(string: (arrCityFilter[indexPath.row].logo ?? "")), placeholderImage: UIImage(named: "AXP"))
                cell.numberLabel.text = "\(arrCityFilter[indexPath.row].totalRate  ?? 0.0)"
                cell.lblName.text = arrCityFilter[indexPath.row].brandName
            }
            else{
                let obj = arrayOfClients?[indexPath.row]
                cell.imageCell?.sd_setImage(with: URL(string: obj?.logo ?? ""), placeholderImage: UIImage(named: "AXP"))
                cell.lblName.text = obj?.brandName
                cell.numberLabel.text = "\(obj?.totalRate ?? 0.0)"
                
            }
        }
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
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedClientId = arrayOfClients?[indexPath.row]._id
        if userType == "user"{
           // Helper.removeInUserDefault(key: "aboutPlace")
            performSegue(withIdentifier: "TabReservationVC", sender: nil)
        }
        else{
           // Helper.removeInUserDefault(key: "aboutPlace")
            if APPLANGUAGE == "en"{
                 HUD.flash(.labeledError(title: "ERROR".localized, subtitle:"Vendor can't make a reservation"), delay: 2)
            }
            else {
                 HUD.flash(.labeledError(title: "ERROR".localized, subtitle:"لا يمكن للبائع إجراء حجز"), delay: 2)
            }
           
        }
    }
}

//MARK:- Extenion SearchBar
extension ReservationVC :UISearchBarDelegate{
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
            self.filterArray = ((self.arrayOfClients?.filter { ($0.brandName?.contains(searchText))! })!)
            self.searchActive = true
            collectionView.reloadData()
        }
    }
}
