//
//  TabReservationVC.swift
//  Davai
//
//  Created by Apple on 4/11/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import PKHUD

class TabReservationVC: UIViewController,UITableViewDelegate,UITableViewDataSource ,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    
    @IBOutlet weak var reserveBtnOut: UIButton!
    
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var didChecked = false
    var obj :ReservedService?
    var empSelectedID :String?
    var arrOfServices :[ServiceClient]?
    var index :Int?
    let pickerView = UIPickerView()
    var time :String?
    var date :String?
    let timePickerView = UIDatePicker()
    var clientId :String?
    var serviceList = [ReservedService]()
    var dic = [String:Any]()
    var arrSize = [Int]()
    var empSelectedTitle :String?
    var searchActive : Bool = false
    var filterArray : [ServiceClient] = []
    let userName = Helper.getFromUserDefault(key: "userName")
    let userType = Helper.getFromUserDefault(key: "userType")
    
    let timePicker = UIDatePicker()
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userType != "skip" && APPLANGUAGE == "en"{
            lblUser.text = "Hi \(userName ?? "")"
        }
        else if userType != "skip" && APPLANGUAGE == "ar"{
            lblUser.text = "مرحبا \(userName ?? "")"
        }
        
        reserveBtnOut.setTitle("Reserve".localized, for: .normal)
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor(displayP3Red: 32/255, green: 60/255, blue: 82/255, alpha: 1)
        textFieldInsideSearchBar?.backgroundColor = UIColor.white
        textFieldInsideSearchBar?.placeholder = "Search"
        searchBar.setImage(UIImage(named: "mySearch"), for: .search, state: .normal)
        
        
        reserveBtnOut.layer.borderWidth = 1
        reserveBtnOut.layer.borderColor = UIColor.white.cgColor
        reserveBtnOut.clipsToBounds = true
        reserveBtnOut.layer.cornerRadius = 15
        searchBar.delegate = self
        setupComponent()
        if CheckInternet.Connection(){
            WebService.instance.getClientServies(clientId: clientId ?? "") { (onSuccess, clientServices ) in
                if onSuccess{
                    self.arrOfServices = clientServices
                    self.tableView.reloadData()
                    self.pickerView.reloadAllComponents()
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
        txtDate.attributedPlaceholder = NSAttributedString(string: "pickDate".localized,
        attributes: [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 32/255, green: 60/255, blue: 82/255, alpha: 1)])
        
        txtTime.attributedPlaceholder = NSAttributedString(string: "pickTime".localized,
        attributes: [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 32/255, green: 60/255, blue: 82/255, alpha: 1)])
        
        showTimePicker()
        showDatePicker()
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
        txtTime.inputAccessoryView = toolbar
         // add datepicker to textField
        txtTime.inputView = timePicker

           }
        
        @objc func doneTimePicker(){
         //For date formate
          let formatter = DateFormatter()
          formatter.dateFormat = "hh:mm"
    //        formatter.amSymbol = "AM"
    //        formatter.pmSymbol = "PM"
          txtTime.text = formatter.string(from: timePicker.date)
            time = txtTime.text
            
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
        txtDate.inputAccessoryView = toolbar
         // add datepicker to textField
        txtDate.inputView = datePicker

           }
        
        @objc func donedatePicker(){
         //For date formate
          let formatter = DateFormatter()
          formatter.dateFormat = "dd MMMM yyyy"
          txtDate.text = formatter.string(from: datePicker.date)
            date = txtDate.text
            
          //dismiss date picker dialog
          self.view.endEditing(true)
        }
        
        @objc func cancelDatePicker(){
         //cancel button dismiss datepicker dialog
          self.view.endEditing(true)
        }
    func dateFormatter(date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMMM yyyy"//this your string date format
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    let convertedDate = dateFormatter.date(from: date)
    dateFormatter.dateFormat = "dd MMMM yyyy"///this is what you want to convert format
    let formattedDate = dateFormatter.string(from: convertedDate!)
    return formattedDate
    }

    //
    override func viewWillAppear(_ animated: Bool) {
        if date != nil {
            txtDate.text = date
        }
        if time != nil {
            txtTime.text = time
        }
    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == txtDate{
//            txtDate.text = date
//        }
//        else if textField == txtTime{
//            txtTime.text = time
//        }
//    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == txtDate{
//            timePickerView.datePickerMode = .date
//            setTimePickerToField(pickerView: timePickerView, textField: txtDate, title: "Date".localized)
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "dd MMMM yyyy"
//            let selectedDate = dateFormatter.string(from: timePickerView.date)
//            date = selectedDate
//        }
//        else if textField == txtTime{
//            timePickerView.datePickerMode = .time
//            setTimePickerToField(pickerView: timePickerView, textField: txtTime, title: "Time".localized)
//            let calendar = Calendar.current
//            let comp = calendar.dateComponents([.hour, .minute], from: timePickerView.date)
//            let hour = comp.hour
//            let minute = comp.minute
//            time = "\(hour ?? 0):\(minute ?? 0)"
//        }
//    }
    //
    
    func setupComponent(){
        pickerView.delegate = self
        pickerView.dataSource = self
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.cornerRadius = 5
        txtDate.delegate = self
        txtTime.delegate = self
    }
    //
    @IBAction func btnMyREservation(_ sender: Any) {
        self.performSegue(withIdentifier: "orders", sender: self)
    }
    
    @IBAction func btnREservePressed(_ sender: Any) {
        if serviceList.count > 0 {
            if serviceList.count == arrSize.count{
                for item in serviceList{
                    if item.employeeID == nil && APPLANGUAGE == "en"{
                        HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "choose an employee for every service"))
                        break
                    }
                    else if item.employeeID == nil && APPLANGUAGE == "en"{
                        HUD.flash(.labeledError(title: "Error".localized, subtitle: "اختيار موظف لكل خدمة"))
                        break
                    }
                    
                }
                if date == nil || date == ""{
                    HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "pleasechooseyourdate".localized))
                }
                else if time == nil || time == ""{
                    HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "pleasechooseyourtime".localized))
                }
                else if !CheckInternet.Connection(){
                    HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Connection".localized))
                }
                else{
                    
                    
                    print(serviceList)
                    
                    
                    HUD.show(.progress)
                    let userId  = Helper.getFromUserDefault(key: "userId")
                    dic["services"] = serviceList
                    dic["clientID"] = clientId ?? ""
                    dic["userID"] = userId
                    dic["dateTime"] = date
                    
                    print(dic)
                    WebService.instance.ppostReservedService(params: dic) { (onSucess) in
                        if onSucess{
                            print("success")
                            HUD.hide()
                            self.txtTime.text = nil
                            self.txtDate.text = nil
                            self.performSegue(withIdentifier: "orders", sender: nil)
                            self.view.makeToast("sucessfully".localized, duration: 2.0, position: .center)
                        }
                        else{
                            
                            HUD.hide()
                            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened".localized))
                        }
                    }
                }
            }
                
            else{
                HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "chooseEmp"))
            }
        }
        else{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "minService".localized))
        }
    }
    ///
    
    
}
extension TabReservationVC{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filterArray.count
        }
        else{
            return arrOfServices?.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TabBarReservationCell", for: indexPath) as! TabBarReservationCell
        if searchActive {
            let obj = filterArray[indexPath.row]
            cell.lblPrice.text = "\(obj.price )"
            cell.lblServiceName.text = obj.brandName
            print("pricece \(obj.price )")
        }
        else{
            let obj = arrOfServices?[indexPath.row]
            cell.lblPrice.text = "\(obj?.price ?? 0)"
            cell.lblServiceName.text = obj?.brandName
            print("pricece \(obj?.price ?? 0)")
        }
        
        cell.txtEmpp.delegate = self
        cell.btnChecked.tag = indexPath.row
        
        cell.txtEmpp.addTarget(self, action: #selector(txtBeginEdit(sender:)), for: .editingDidBegin)
        cell.txtEmpp.addTarget(self, action: #selector(txtEndEdit(sender:)), for: .editingDidEnd)
        cell.btnChecked.addTarget(self,action:#selector(checkPressed(sender:)),for: .touchUpInside)
        
        return cell
    }
    @objc func checkPressed(sender:UIButton){
        guard let cell = sender.superview?.superview?.superview as? TabBarReservationCell else {return}
        if cell.view2.isHidden == true{
            cell.view2.isHidden = false
            cell.btnChecked.setImage(UIImage(named: "checked.png"), for: UIControlState.normal)
            //            obj?.price = "\(arrOfServices?[sender.tag].price ?? 0)"
            //            obj?.serviceID = arrOfServices?[sender.tag].servicesID ?? ""
            
        }
        else{
            cell.view2.isHidden = true
            cell.btnChecked.setImage(UIImage(named: "unchecked.png"), for: UIControlState.normal)
            for i in 0..<serviceList.count{
                if serviceList[i].servicesID == arrOfServices?[sender.tag].servicesID{
                    serviceList.remove(at: i)
                    arrSize.remove(at:0)
                    break
                }
            }
            
        }
    }
    //
    @objc func txtBeginEdit(sender:UITextField){
        guard let cell = sender.superview?.superview?.superview?.superview as? TabBarReservationCell else {return}
        setPickerToField(pickerView :pickerView,textField: cell.txtEmpp, title: "Employees".localized)
        index = sender.tag
    }
    @objc func txtEndEdit(sender:UITextField){
        guard let cell = sender.superview?.superview?.superview?.superview as? TabBarReservationCell else {return}
        cell.txtEmpp.text = empSelectedTitle
        if empSelectedID != nil{
            let reservedObj = ReservedService(servicesID: arrOfServices?[sender.tag].servicesID ?? "asd", employeeID: empSelectedID ?? "cc", price: "\(arrOfServices?[sender.tag].price ?? 10)")
            serviceList.append(reservedObj)
            empSelectedID = nil
            arrSize.append(0)
            
        }
        print("count1 \(serviceList.count)")
    }
}
//
// MARK:_  Fill PickerView
extension TabReservationVC{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if index != nil{
            return (arrOfServices?[index!].employees.count) ?? 0
        }
        else{
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrOfServices?[index!].employees[row].fullname
    }
    // didSelect
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        empSelectedID = arrOfServices?[index!].employees[row].id
        empSelectedTitle = arrOfServices?[index!].employees[row].fullname
    }
}
//MARK:- Extenion SearchBar
extension TabReservationVC :UISearchBarDelegate{
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
    func searchBar(_ searchBar: UISearchBar,textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        if searchText == ""{
            self.searchActive = false
            tableView.reloadData()
        }
        else{
            self.filterArray = (self.arrOfServices?.filter { ($0.brandName.contains(searchText)) })!
            self.searchActive = true
            tableView.reloadData()
        }
    }
}
