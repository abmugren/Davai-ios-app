//
//  ReservationDetailsUser.swift
//  Davai
//
//  Created by Apple on 2/14/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import PKHUD

class ReservationDetailsUser: UIViewController, UITableViewDelegate, UITableViewDataSource,PassDataBackDelegate {
    
    @IBOutlet weak var btnReReserve: ANCustomButton!
    @IBOutlet weak var btnSelectServices: UIButton!
    
    @IBOutlet weak var btnReserve: ANCustomButton!
    @IBOutlet weak var lblEditEmployee: UILabel!
    @IBOutlet weak var btnEditReservation: UIButton!
    
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var btnCancel: ANCustomButton!
    @IBOutlet weak var imgOrder: UIImageView!
    
    
    @IBOutlet weak var rescudale: UILabel!
    @IBOutlet weak var status: UILabel!
    var clientId :String = Helper.getFromUserDefault(key: "clientId") ?? ""
    var selectedOrderId :String?
    var arrayOfService :[ServiceLangg]?
    var arrayOfServiceupdated :[ReservedService] = []
    let userType = UserDefaults.standard.string(forKey: "userType")
    let userId = UserDefaults.standard.string(forKey: "userId")
    var orderClientId :String?
    var vc = ServicesViewController()
    var dic = [String:Any]()
    
    var date = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(date)
        txtDate.text = date
        //btnReserve.setTitle("Reserved".localized, for: .normal)
        btnCancel.setTitle("Cancel".localized, for: .normal)
        btnReReserve.setTitle("ReReServed".localized, for: .normal)
        btnEditReservation.setTitle("EditReservation".localized, for: .normal)
        btnSelectServices.setTitle("selectService".localized, for: .normal)
        status.text = "status".localized
        rescudale.text = "Rescudale".localized
        //txtDate.text = "pickDate".localized
        txtTime.text = "pickTime".localized
        lblEditEmployee.text = "editServces".localized
        vc.delegatee = self
        tableView.delegate = self
        tableView.dataSource = self
        if CheckInternet.Connection(){
                HUD.show(.progress)
                WebService.instance.getOrderDetail(bookingId: selectedOrderId ?? "" ) { (onSuccess, services,order)  in
                    if onSuccess{
                        self.arrayOfService = services
                        self.tableView.reloadData()
                        self.imgOrder?.sd_setImage(with: URL(string: order?.img ?? ""), placeholderImage: UIImage(named: "AXP"))
                        self.lblDate.text = String(order?.date?.prefix(10) ?? "")
                        self.lblFirstName.text = order?.brandName
                        self.orderClientId = order?.clientId
                        HUD.hide()
                    }
                    else{
                        HUD.hide()
                    }
                }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? ServicesViewController
        {
            if (segue.identifier == "toOrders") {
                //destinationVC.delegatee = self
                destinationVC.arrOfService = arrayOfService
                destinationVC.time = txtDate.text
                destinationVC.date = txtDate.text
                destinationVC.orderClientId = orderClientId
                destinationVC.delegatee = self
                
            }
        }
    }
    
    @IBAction func btnUpdateORder(_ sender: Any) {
        print("count pudated \(arrayOfServiceupdated.count)")
       // if arrayOfServiceupdated != nil {
            HUD.show(.progress)
        var type :String?
        var dicJson = [[String:String]]()
        var dicObj = [String:String]()
        for service in arrayOfServiceupdated{
            dicObj["servicesID"] = service.servicesID
            dicObj["price"] = service.price
            dicObj["employeeID"] = service.employeeID
            dicJson.append(dicObj)
        }
        dic["services"] = dicJson
        dic["bookingID"] = selectedOrderId ?? ""
        dic["dateTime"] = "\(txtDate.text ?? "9")\(txtTime.text ?? "9")"
        
        if userType == "user" {
            type = "updateBooking"
        }
        else if userType == "vendor"{
            type = "updateClientBooking"
        }
        
        
            
        WebService.instance.updateReservedService(type:type ?? "", params: dic) { (onSucess) in
                if onSucess{
                    print("success")
                    HUD.hide()
                    self.txtTime.text = nil
                    self.txtDate.text = nil//toOrdersfromDetail
                    self.view.makeToast("sucessfully".localized, duration: 2.0, position: .center)
                   self.performSegue(withIdentifier: "toOrdersfromDetail", sender: nil)
                }
                else{
                    HUD.hide()
                    HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened".localized))
                }
            }
     //   }
        
    }
    @IBAction func btnSelectService(_ sender: Any) {
        performSegue(withIdentifier: "toOrders", sender: nil)
    }
    
    @IBAction func btnCancelOrder(_ sender: Any) {
        if  CheckInternet.Connection(){
              HUD.show(.progress)
            if userType == "user"{
                WebService.instance.cancelOrder(id: userId ?? "", bookingId: selectedOrderId ?? "", orderType: "user") { (onSuccess) in
                    if onSuccess{
                        self.performSegue(withIdentifier: "toOrdersfromDetail", sender: nil)
                        print("successsss")
                         HUD.hide()
                    }
                    else{
                         HUD.hide()
                    }
                }
            }
            else if userType == "vendor"{
                WebService.instance.cancelOrder(id: clientId , bookingId: selectedOrderId ?? "", orderType: "vendor") { (onSuccess) in
                    if onSuccess{
                        self.performSegue(withIdentifier: "toOrdersfromDetail", sender: nil)
                        print("toOrdersfromDetail")
                        HUD.hide()
                    }
                    else{
                        HUD.hide()
                    }
                }
            }
        }
        else{
             HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Connection".localized))
        }
    }
    @IBAction func btnDone(_ sender: Any) {
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
//
extension ReservationDetailsUser{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfService?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderDetailCell", for: indexPath) as! orderDetailCell
        cell.lblServiceName.text = arrayOfService?[indexPath.row].en
        return cell
    }
}
extension ReservationDetailsUser{
    func userDidEnterInformation(updatedServices: [ServiceLangg]) {
        for item in updatedServices{
            let obj = ReservedService.init(servicesID: item.id!, employeeID: item.empID!, price: "\(item.price!)" )
            arrayOfServiceupdated.append(obj)
            //arrayOfServiceupdated.insert(obj, at: 0)
        }
    }
}
