//
//  UserOrderVC.swift
//  Davai
//
//  Created by Apple on 4/24/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import PKHUD

class UserOrderVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let userId = UserDefaults.standard.string(forKey: "userId")
    let userType = UserDefaults.standard.string(forKey: "userType")
    let clientId = UserDefaults.standard.string(forKey: "clientId")
    
    var arrayOfUserOrders :[UserOrder]?
    var arrayOfVendorOrders :[VenodrOrder]?
    var searchActive : Bool = false
    var filterArray : [UserOrder] = []
    var filterArrayVendor : [VenodrOrder] = []
    private var selectedOrderId :String?
    var selectedDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor(displayP3Red: 32/255, green: 60/255, blue: 82/255, alpha: 1)
        textFieldInsideSearchBar?.backgroundColor = UIColor.white
        textFieldInsideSearchBar?.placeholder = "Search"
        searchBar.setImage(UIImage(named: "mySearch"), for: .search, state: .normal)
        
        if CheckInternet.Connection(){
            //HUD.show(.progress)
            if userType == "user"{
                WebService.instance.getUserOrders(userId: userId ?? "") { (onSuccess, orders) in
                    if onSuccess{
                        self.arrayOfUserOrders = orders
                        self.tableView.reloadData()
                        HUD.hide()
                    }
                    else{
                        HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened".localized))
                        HUD.hide()
                    }
                }
            }
            else if userType == "vendor"{
                WebService.instance.getVendorOrders(clientId: clientId ?? "") { (onSuccess, orders) in
                    if onSuccess {
                        self.arrayOfVendorOrders = orders
                        self.tableView.reloadData()
                        HUD.hide()
                    }
                    else{
                        HUD.flash(.labeledError(title:"ERROR".localized, subtitle: "ErrorHappened".localized))
                        HUD.hide()
                    }
                }
            }
        }
        else{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Connection".localized))
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let resUserDetail = segue.destination as? ReservationDetailsUser
        {
            if (segue.identifier == "toOrderDetail") {
                resUserDetail.selectedOrderId = selectedOrderId
                resUserDetail.date = selectedDate
            }
        }
    }
    
}
//
extension UserOrderVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userType == "user"{
            if searchActive{
                return filterArray.count
            }
            else{
                return arrayOfUserOrders?.count ?? 0
            }
        }
        else if userType == "vendor"{
            if searchActive{
                return filterArray.count
            }
            else{
                return arrayOfVendorOrders?.count ?? 0
            }
        }
        else{
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserOrderCell", for: indexPath) as! UserOrderCell
        cell.btnEdit.tag = indexPath.row
        if userType == "user"{
            if searchActive{
                let obj = filterArray[indexPath.row]
                cell.lblBrandName.text = obj.brandName
                cell.lblDate.text = String(obj.dateTime?.prefix(10) ?? "" )
                cell.lblState.text = "Reserved".localized
                cell.imgLogo?.sd_setImage(with: URL(string: obj.logo ?? "" ), placeholderImage: UIImage(named: "AXP"))
            }
            else {
                let obj = arrayOfUserOrders?[indexPath.row]
                cell.lblBrandName.text = obj?.brandName
                cell.lblDate.text = String(obj?.dateTime?.prefix(10) ?? "")
                cell.lblState.text = "Reserved".localized
                cell.imgLogo?.sd_setImage(with: URL(string: obj?.logo ?? ""), placeholderImage: UIImage(named: "AXP"))
            }
        }
        else if userType == "vendor"{
            if searchActive{
                let obj = filterArrayVendor[indexPath.row]
                cell.lblBrandName.text = obj.firstname
                cell.lblDate.text = String(obj.dateTime?.prefix(10) ?? "" )
                cell.lblState.text = "Reserved".localized
                cell.imgLogo?.sd_setImage(with: URL(string: obj.img ?? "" ), placeholderImage: UIImage(named: "AXP"))
            }
            else{
                let obj = arrayOfVendorOrders?[indexPath.row]
                cell.lblBrandName.text = obj?.firstname
                cell.lblDate.text = String(obj?.createdAt?.prefix(10) ?? "")
                cell.lblState.text = "Reserved".localized
                cell.imgLogo?.sd_setImage(with: URL(string: obj?.img ?? ""), placeholderImage: UIImage(named: "AXP"))
            }
        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if userType == "user"{
            if searchActive {
                selectedOrderId = filterArray[indexPath.row]._id
                
            }
            else {
                selectedOrderId = arrayOfUserOrders?[indexPath.row]._id
                let mySelectedDate = arrayOfUserOrders?[indexPath.row].dateTime
                selectedDate = String(mySelectedDate?.prefix(10) ?? "")
            }
        }
         else if userType == "vendor" {
            if searchActive {
                selectedOrderId = filterArrayVendor[indexPath.row]._id
                
            }
            else {
                selectedOrderId = arrayOfVendorOrders?[indexPath.row]._id
            }
        }
       performSegue(withIdentifier: "toOrderDetail", sender: nil)
    }
}
//MARK:- Extenion SearchBar
extension UserOrderVC :UISearchBarDelegate{
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
            tableView.reloadData()
        }
        else{
            if userType == "user"{
                self.filterArray = (self.arrayOfUserOrders?.filter { (($0.brandName?.contains(searchText) ?? false)) })!
                self.searchActive = true
                tableView.reloadData()
            }
            else if userType == "vendor"{
                self.filterArrayVendor = (self.arrayOfVendorOrders?.filter { ($0.firstname!.contains(searchText)) })!
                self.searchActive = true
                tableView.reloadData()
            }
        }
    }
}
