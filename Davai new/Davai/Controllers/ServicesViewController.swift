
//
//  ServicesViewController.swift
//  Davai
//
//  Created by Mac on 5/27/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit

class ServicesViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
 
    @IBOutlet weak var closeBtn: UIImageView!
    var time :String?
    var date :String?
    var index :Int?
    let pickerView = UIPickerView()
    var arrOfService :[ServiceLangg]?
    var empSelectedID :String?
    var empSelectedTitle :String?
    var orderClientId :String?
     weak var delegatee: PassDataBackDelegate? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupComponent()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        closeBtn.isUserInteractionEnabled = true
        closeBtn.addGestureRecognizer(tapGestureRecognizer)
        
        if CheckInternet.Connection(){
            print("clientIDDdd \(orderClientId ?? "")")
            WebService.instance.GetServicesById(clientId: orderClientId ?? "") { (onSuccess, clientServices) in
                if onSuccess {
                    for service in self.arrOfService!{
                        print("serId1 \(service.id)")
                        for item in clientServices!{
                            print("serId2 \(item.servicesID)")
                            if service.id == item.servicesID{
                    
                                service.emps = item.employees
                                print("ddd\(item.employees.count)")
                            }
                        }
                        self.tableView.reloadData()
                        self.pickerView.reloadAllComponents()
                    }
                }
                else{
                    
                }
            }
        }
        else{
            
        }
    }
    
@objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
    dismiss(animated: true, completion: nil)
}
    //
    @IBAction func btnUpdatePressed(_ sender: Any) {
        if arrOfService != nil {
            delegatee?.userDidEnterInformation(updatedServices: arrOfService!)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    func setupComponent(){
        pickerView.delegate = self
        pickerView.dataSource = self
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.cornerRadius = 5
        
    }
}
//


extension ServicesViewController :UITextFieldDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfService?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TabBarReservationCell", for: indexPath) as! TabBarReservationCell
        cell.lblPrice.text = "\(arrOfService?[indexPath.row].price ?? 0)"
            cell.lblServiceName.text = arrOfService?[indexPath.row].en
        cell.txtEmpp.text = arrOfService?[indexPath.row].empName
        
        cell.btnChecked.setImage(UIImage(named: "checked.png"), for: UIControlState.normal)
        cell.txtEmpp.delegate = self
        cell.btnChecked.tag = indexPath.row
        cell.txtEmpp.addTarget(self, action: #selector(txtBeginEdit(sender:)), for: .editingDidBegin)
        cell.txtEmpp.addTarget(self, action: #selector(txtEndEdit(sender:)), for: .editingDidEnd)
    cell.btnChecked.addTarget(self,action:#selector(checkPressed(sender:)),for: .touchUpInside)
  
            return cell
    }
    //
    @objc func checkPressed(sender:UIButton){
        guard (sender.superview?.superview?.superview as? TabBarReservationCell) != nil else {return}
    }
    //
    @objc func txtBeginEdit(sender:UITextField){
        guard let cell = sender.superview?.superview?.superview?.superview as? TabBarReservationCell else {return}
        setPickerToField(pickerView :pickerView,textField: cell.txtEmpp, title: "Employees")
        index = sender.tag
    }
    @objc func txtEndEdit(sender:UITextField){
        guard let cell = sender.superview?.superview?.superview?.superview as? TabBarReservationCell else {return}
        cell.txtEmpp.text = empSelectedTitle
        arrOfService?[sender.tag].empID = empSelectedID
        arrOfService?[sender.tag].empName = empSelectedTitle
        
        }
    }

//
extension ServicesViewController :UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if index != nil{
            return (arrOfService?[index!].emps?.count) ?? 0
        }
        else{
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrOfService?[index!].emps?[row].fullname

    }
    // didSelect
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        empSelectedID = arrOfService?[index!].emps?[row].id
        empSelectedTitle = arrOfService?[index!].emps?[row].fullname
    }
}
// protocol used for sending data back
protocol PassDataBackDelegate: class {
    func userDidEnterInformation(updatedServices: [ServiceLangg])
}
