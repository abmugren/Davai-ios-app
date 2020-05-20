//
//  ServicesPlaceVC.swift
//  Davai
//
//  Created by Apple on 2/5/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import PKHUD
import Cosmos
class ServicesPlaceVC: UIViewController, UITableViewDataSource, UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    @IBOutlet weak var lblRate: UILabel!
    
    @IBOutlet weak var btnReserve: GradientButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var vendorName: UILabel!
    @IBOutlet weak var lblNumberFavorite: UILabel!
    @IBOutlet weak var viewRate: CosmosView!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var txtTime: UITextField!
    
    @IBOutlet var reserveView: UIView!
    @IBOutlet weak var dismissView: UIButton!
    
    @IBOutlet weak var reserveBtn: GradientButton!
    @IBOutlet weak var selectEmployeeTF: UITextField!
    
    var favId :String = ""
    var obj :ReservedService?
    var empSelectedID :String?
    var arrOfServices :[ServiceClient]?
    var index :Int?
    let pickerView = UIPickerView()
    var time :String?
    var date :String?
    let timePickerView = UIDatePicker()
    let userType = Helper.getFromUserDefault(key: "userType")
    var clientId = Helper.getFromUserDefault(key: "clientId")
    let userId = Helper.getFromUserDefault(key: "userId")
    let  fromSideMenu = Helper.getFromUserDefault(key: "aboutPlace")
    let places = Helper.getFromUserDefault(key: "places")
    var placeId = Helper.getFromUserDefault(key: "placeId")
    let clientCover = Helper.getFromUserDefault(key: "clientCover")
    
    var serviceList = [ReservedService]()
    var dic = [String:Any]()
    var arrSize = [Int]()
    var empSelectedTitle :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.string(forKey: "userType") == "skip"{
            self.view.isHidden = true
        }
        if UserDefaults.standard.string(forKey: "userType") == "user"{
            self.btnReserve.isHidden = false
        }
        viewRate.didFinishTouchingCosmos = didFinishTouchingCosmos
        pickerView.delegate = self
        pickerView.dataSource = self
        txtDate.delegate = self
        txtTime.delegate = self
        if clientCover != "" && clientCover != nil {
            coverImage.sd_setImage(with: URL(string: clientCover!), placeholderImage: UIImage(named: "AXP"))
        }
        if userType == "user" || userType == "skip" || favId != ""{
            if favId != "" {
                placeId = favId
            }
            WebService.instance.getClientVendorById(clientId: placeId ?? "") { (onSucess, client) in
                if onSucess{
                    self.logoImage?.sd_setImage(with: URL(string: (client?.logo ?? "")), placeholderImage: UIImage(named: "AXP"), completed: nil)
                    self.coverImage?.sd_setImage(with: URL(string: (client?.cover ?? "")), placeholderImage: UIImage(named: "AXP"), completed: nil)
                    self.vendorName.text = client?.brandName
                }
            }
        }
        else if userType == "vendor"{
            var id :String?
            if self.fromSideMenu == "true"{
                id = clientId
            }
            else {
                id = placeId
            }
            WebService.instance.getClientVendorById(clientId: id ?? "") { (onSucess, client) in
                if onSucess{
                    self.logoImage?.sd_setImage(with: URL(string: (client?.logo ?? "")), placeholderImage: UIImage(named: "AXP"), completed: nil)
                    self.coverImage?.sd_setImage(with: URL(string: (client?.cover ?? "")), placeholderImage: UIImage(named: "AXP"), completed: nil)
                    self.vendorName.text = client?.brandName
                }
            }
        }
        if fromSideMenu != "true"{
            if CheckInternet.Connection(){
                HUD.show(.progress)
                WebService.instance.getTotalClinetFav(clientID: placeId ?? "") { (onSuccess, numOfFav) in
                    if onSuccess{
                        self.lblNumberFavorite.text = "\(numOfFav ?? 0)"
                        HUD.hide()
                    }
                    else{
                        HUD.hide()
                        HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened".localized))
                    }
                }
                
                WebService.instance.getClientVendorById(clientId: placeId ?? "") { (onScucess, client) in
                    if onScucess{
                        if client?.totalRateD != nil{
                            self.lblRate.text = "\(client?.totalRateD ?? 0.0)"
                        }
                        else if client?.totalRateI != nil{
                            self.lblRate.text = "\(client?.totalRateI ?? 0)"
                        }
                        HUD.hide()
                    }
                    else{
                        HUD.hide()
                        HUD.flash(.labeledError(title: "ERROR".localized, subtitle:"ErrorHappened".localized))
                    }
                }
                WebService.instance.getClientServies(clientId: placeId ?? "") { (onSuccess, clientServices ) in
                    if onSuccess{
                        self.arrOfServices = clientServices
                        self.tableView.reloadData()
                        self.pickerView.reloadAllComponents()
                    }
                    else{
                        HUD.hide()
                        HUD.flash(.labeledError(title: "ERROR".localized, subtitle:"ErrorHappened".localized))
                    }
                }
            }
            else{
                HUD.flash(.labeledError(title:"ERROR".localized, subtitle: "Connection".localized))
            }
        }
        
        else if  fromSideMenu == "true"{ // number of favorites
            if CheckInternet.Connection(){
                HUD.show(.progress)
                WebService.instance.getTotalClinetFav(clientID: clientId ?? "") { (onSuccess, numOfFav) in
                    if onSuccess{
                        self.lblNumberFavorite.text = "\(numOfFav ?? 0)"
                        HUD.hide()
                    }
                    else{
                        HUD.hide()
                        HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened".localized))
                    }
                }
                
                WebService.instance.getClientVendorById(clientId: clientId ?? "") { (onScucess, client) in
                    if onScucess{
                        if client?.totalRateD != nil{
                            self.lblRate.text = "\(client?.totalRateD ?? 0.0)"
                        }
                        else if client?.totalRateI != nil{
                            self.lblRate.text = "\(client?.totalRateI ?? 0)"
                        }
                        HUD.hide()
                    }
                    else{
                        HUD.hide()
                        HUD.flash(.labeledError(title:"ERROR".localized, subtitle: "ErrorHappened".localized))
                    }
                }
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
                HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Connection".localized))
            }
        }
        
        
        
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.cornerRadius = 5
        
        setUpViews()
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtDate{
            txtDate.text = date
        }
        else if textField == txtTime{
            txtTime.text = time
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtDate{
            timePickerView.datePickerMode = .date
            setTimePickerToField(pickerView: timePickerView, textField: txtDate, title: "Date".localized)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            let selectedDate = dateFormatter.string(from: timePickerView.date)
          date = selectedDate
        }
        else if textField == txtTime{
            timePickerView.datePickerMode = .time
            setTimePickerToField(pickerView: timePickerView, textField: txtTime, title: "Time")
            let calendar = Calendar.current
            let comp = calendar.dateComponents([.hour, .minute], from: timePickerView.date)
            let hour = comp.hour
            let minute = comp.minute
            time = "\(hour ?? 0):\(minute ?? 0)"
        }
        
    }
    func setUpViews(){
        coverImage.layer.cornerRadius = 10
        coverImage.layer.masksToBounds = true
        
        logoImage.layer.cornerRadius = 10
        logoImage.layer.masksToBounds = true
        
        reserveBtn.layer.borderWidth = 2
        reserveBtn.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func btnPopReserve(_ sender: Any) {
        if date == nil{
            HUD.flash(.labeledError(title: "", subtitle: "pleasechooseyourdate".localized))
        }
        else if time == nil{
            HUD.flash(.labeledError(title: "complete your date ", subtitle: "pleasechooseyourtime".localized))
        }
        else if !CheckInternet.Connection(){
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Connection".localized))
        }
        else{
            HUD.show(.progress)
            var dicJson = [[String:String]]()
            var dicObj = [String:String]()
            //let dicc  = [["servicesID":"5c801d091138ee4158226edc","price":"55","employeeID":"5c87a30a9abf7f53dca40582"]]
            for service in serviceList{
                dicObj["servicesID"] = service.servicesID
                dicObj["price"] = service.price
                dicObj["employeeID"] = service.employeeID
                dicJson.append(dicObj)
            }
            print("myDic \(dicJson)")
            dic["services"] = dicJson
            dic["clientID"] = placeId
            dic["userID"] = userId
            dic["dateTime"] = date
            WebService.instance.postReservedService(params: dic) { (onSucess) in
                if onSucess{
                    print("success")
                    HUD.hide()
                    self.animateOut()
                    self.txtTime.text = nil
                    self.txtDate.text = nil
                    self.tableView.reloadData()
                    self.view.makeToast("sucessfully".localized, duration: 2.0, position: .center)
                }
                else{
                    HUD.hide()
                    HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened".localized))
                }
            }
        }
     
        
    }
    @IBAction func btnMainReserve(_ sender: Any) {
        if serviceList.count > 0 {
            if serviceList.count == arrSize.count{
                for item in serviceList{
                    if item.employeeID == nil{
                        HUD.flash(.labeledError(title:"ERROR".localized, subtitle: "chooseEmp".localized))
                        break
                    }
                }
                animateIn()
            }
            
            else{
                HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "chooseEmp".localized))
            }
        }
        else{
            HUD.flash(.labeledError(title:"ERROR".localized, subtitle: "minService".localized))
        }
       
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfServices?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "serviceVendorCell", for: indexPath) as! serviceVendorCell
        
     
        let obj = arrOfServices?[indexPath.row]
        cell.lblPrice.text = "\(obj?.price ?? 0)"
        cell.lblName.text = obj?.brandName
        cell.txtEmp.delegate = self
//        if obj?.employees.count ?? 0 > 0 {
//            cell.txtEmp.text = obj?.employees[0].fullname
//        }
        
        cell.txtEmp.addTarget(self, action: #selector(txtBeginEdit(sender:)), for: .editingDidBegin)
        cell.txtEmp.addTarget(self, action: #selector(txtEndEdit(sender:)), for: .editingDidEnd)
        
        cell.btnCheckBox.tag = indexPath.row
        cell.btnCheckBox.addTarget(self,action:#selector(checkPressed(sender:)),for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    ////
    private func didFinishTouchingCosmos(_ rating: Double) {
        let userId = Helper.getFromUserDefault(key: "userId")
        let params = ["clientID":clientId ?? "","userID":userId ?? "","rate":rating] as [String : Any]
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
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Connection".localized))
        }
        viewRate.didFinishTouchingCosmos = didFinishTouchingCosmos
        setUpViews()
    }
    ////
    @objc func checkPressed(sender:UIButton){
        guard let cell = sender.superview?.superview?.superview as? serviceVendorCell else {return}
        //let indexPath = table.indexPath(for:cell)
        if cell.view2.isHidden == true{
            cell.view2.isHidden = false
            cell.btnCheckBox.setImage(UIImage(named: "checked.png"), for: UIControlState.normal)
            obj?.price = "\(arrOfServices?[sender.tag].price ?? 0)"
            obj?.servicesID = arrOfServices?[sender.tag].servicesID ?? ""
            arrSize.append(0)
        }
        else{
            cell.view2.isHidden = true
            cell.btnCheckBox.setImage(UIImage(named: "unchecked.png"), for: UIControlState.normal)
            //let reservedObj = ReservedService(serviceID: arrOfServices?[sender.tag].servicesID ?? "", employeeID: empSelectedID ?? "", price: "\(arrOfServices?[sender.tag].price ?? 0)")
            
            for i in 0..<serviceList.count{
                if serviceList[i].servicesID == arrOfServices?[sender.tag].servicesID{
                    serviceList.remove(at: i)
                    arrSize.remove(at:0)
                    break
                }
            }
        }
    }
    ///
    @objc func txtBeginEdit(sender:UITextField){
        guard let cell = sender.superview?.superview?.superview?.superview as? serviceVendorCell else {return}
        setPickerToField(pickerView :pickerView,textField: cell.txtEmp, title: "Employees".localized)
        print("txt pressed")
        index = sender.tag
        //let indexPath = table.indexPath(for:cell)
        
    }
    @objc func txtEndEdit(sender:UITextField){
        guard let cell = sender.superview?.superview?.superview?.superview as? serviceVendorCell else {return}
        cell.txtEmp.text = empSelectedTitle
//        for i in 0..<serviceList.count{
//            if serviceList[i].serviceID == "\(arrOfServices?[sender.tag].price ?? 0)"{
//                serviceList[i].employeeID = empSelectedID!
//            }
          //  else{
        
           // }
        //}
        if empSelectedID != nil{
            let reservedObj = ReservedService(servicesID: arrOfServices?[sender.tag].servicesID ?? "", employeeID: empSelectedID ?? "", price: "\(arrOfServices?[sender.tag].price ?? 0)")
            serviceList.append(reservedObj)
            empSelectedID = nil
           
        }
//        else{
//            obj?.employeeID = arrOfServices?[sender.tag].employees[0].id ?? ""
//            serviceList.append(obj!)
//            empSelectedID = nil
//            obj = nil
////            let reservedObj = ReservedService(serviceID: arrOfServices?[sender.tag].servicesID ?? "", employeeID: arrOfServices?[sender.tag].employees[0].id ?? "" , price: "\(arrOfServices?[sender.tag].price ?? 0)")
////            serviceList.append(reservedObj)
//        }
       print("count1 \(serviceList.count)")
        //let indexPath = table.indexPath(for:cell)
        
    }
    ///
    func animateIn(){
        self.view.addSubview(reserveView)
        reserveView.center = self.view.center
        reserveView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        reserveView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.reserveView.alpha = 1
            self.reserveView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.reserveView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.reserveView.alpha = 0
        }) { (success: Bool) in
            self.reserveView.removeFromSuperview()
        }
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        animateOut()
    }
    
    
}
// MARK:_  Fill PickerView
extension ServicesPlaceVC{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if index != nil{
            return (arrOfServices?[index!].employees.count) ?? 0
        }
        else{
         return 0
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
