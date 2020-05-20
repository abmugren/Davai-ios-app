//
//  ServicePickerVC.swift
//  Davai
//
//  Created by MacBook  on 2/3/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import PKHUD

protocol Servicess {
    func didtappedOnService(id: String, price: Int, employees: [String])
}

class ServicePickerVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var closeBtn: UIImageView!
	@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var arrayOfServices :[Service]?
    var serviceList = [VendorService]()
    //weak var delegate: PassListDelegate? = nil
    var myDelegate: Servicess?
    var arrEmps : [String] = []
    var index:Int?
    
	override func viewDidLoad() {
        super.viewDidLoad()
		print("countt \(arrayOfServices?.count)")
		tableView.delegate = self
		tableView.dataSource = self
		
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        closeBtn.isUserInteractionEnabled = true
        closeBtn.addGestureRecognizer(tapGestureRecognizer)
        
        titleLabel.text = "chooseS".localized

    }
	@objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
		dismiss(animated: true, completion: nil)
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return arrayOfServices?.count ?? 1
       
	}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myDelegate?.didtappedOnService(id: arrayOfServices?[indexPath.row].serviceID ?? "", price: 500, employees: ["asde","asdsad"])
        dismiss(animated: true, completion: nil)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? servicesCell{
            cell.priceTF.layer.borderWidth = 1
            cell.priceTF.attributedPlaceholder = NSAttributedString(string: "EnterPrice".localized,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            
            cell.numberTF.layer.borderWidth = 1
            cell.numberTF.attributedPlaceholder = NSAttributedString(string: "enter".localized,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])

            if(APPLANGUAGE == "en"){
                cell.serviceName.text = arrayOfServices?[indexPath.row].titleEN
            }
            else {
                cell.serviceName.text = arrayOfServices?[indexPath.row].titleAr
            }
            
            cell.btnAddEmp.tag = indexPath.row
            cell.btnCheck.tag = indexPath.row
            cell.btnSave.tag = indexPath.row
            cell.btnAddEmp.addTarget(self,action:#selector(addEmpPressed(sender:)),for: .touchUpInside)
            cell.btnCheck.addTarget(self,action:#selector(checkPreessed(sender:)),for: .touchUpInside)
            cell.btnSave.addTarget(self,action:#selector(appendService(sender:)),for: .touchUpInside)

            return cell
        }
        else {
           return UITableViewCell()
        }
	}
    // MARK:- Add Emp Target
    @objc func addEmpPressed(sender:UIButton)
    {
        let serviceCellObj :servicesCell?
        guard let cell = sender.superview?.superview?.superview?.superview?.superview as? servicesCell else {return}
        let indexPath = tableView.indexPath(for:cell)
       
            cell.insertNewEmp(sender: sender) { (onSucess,emps) in
                if onSucess{
                    print("empsss \(emps?.count)")
                    self.arrEmps = emps ?? []
                    self.index = sender.tag
                }
                else {
                }
            }
    }
    @objc func checkPreessed(sender:UIButton)
    {
        var serviceCellObj :servicesCell?
        guard let cell = sender.superview?.superview?.superview as? servicesCell else {return}
        
        if cell.btnCheck.isSelected == false{
            if serviceList.count >= 1 {
                for i in 0..<serviceList.count - 1{
                    if serviceList[i].servicesID == arrayOfServices?[sender.tag].serviceID{
                        serviceList.remove(at: i)
                        cell.priceTF.text = ""
                        cell.numberTF.text = ""
                        cell.emps.removeAll()
                        cell.tableView.reloadData()
                        break
                    }
                }
            }
          
        }
        else{
            
        }
    }
    @objc func appendService(sender:UIButton)
    {
        var serviceCellObj :servicesCell?
        guard let cell = sender.superview?.superview as? servicesCell else {return}
        
        if cell.priceTF.text == "" || cell.priceTF.text == nil{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "EnterPrice".localized), delay: 2.5)
        }
        else if cell.btnCheck.isSelected == false{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "SelectService".localized), delay: 2.5)
        }
        else if arrEmps.count <= 0{
            HUD.flash(.labeledError(title:  "ERROR".localized, subtitle: "addEmp".localized), delay: 2.5)
        }
        else{
            if sender.tag == index {
                let servicePrice = Int(cell.priceTF.text ?? "0") ?? 0
                let service = VendorService.init(servicesID: arrayOfServices?[sender.tag].serviceID ?? "a", emp: self.arrEmps, price: servicePrice)
                serviceList.append(service)
                cell.priceTF.text = ""
                cell.numberTF.text = ""
            }
        }
    }
    //
    @IBAction func btnCashPressed(_ sender: Any) {
        myDelegate?.didtappedOnService(id: "asdasdd", price: 60, employees: ["sadad","efw"])
    self.dismiss(animated: true, completion: nil)
    }
    
}
// protocol used for sending data back

