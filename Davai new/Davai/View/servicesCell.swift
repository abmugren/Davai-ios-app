//
//  servicesCell.swift
//  Davai
//
//  Created by Apple on 2/4/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import PKHUD
import UICheckbox_Swift

class servicesCell: UITableViewCell, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCheck: UICheckbox!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var viewEmpConstraint: NSLayoutConstraint!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var btnAddEmp: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var viewEmplyees: UIView!
    
    @IBOutlet weak var numberTF: UITextField!
    var arrayOfSelectedService :[String] = []
    var emps : [String] = []

    override func awakeFromNib() {
        tableView.delegate = self
        tableView.dataSource = self

    }
    
}
extension servicesCell {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emps.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let empName = emps[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! VendorServiceCell
//        cell?.textLabel?.text = empName
        cell.txtService.text = empName
        cell.btnReomve.tag = indexPath.row
        cell.btnReomve.addTarget(self, action:#selector(buttonClicked), for: .touchUpInside)

        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            emps.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    @objc func insertNewEmp(sender:UIButton, completion :@escaping ( _ onSucess :Bool , _ emps:[String]?) -> ()){
        
        if numberTF.text! == ""{
            HUD.flash(.labeledError(title: "Wrong", subtitle: "Enter your employee name"), delay: 2)
        }
    
        else{
        emps.append(numberTF.text!)
        let indexPath = IndexPath(row: emps.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        numberTF.text! = ""
        priceTF.text = ""
            print("empps \(self.emps.count)")
            print("empps \(self.emps)")

        completion(true, emps)
            
        }
    }
    
    @objc func buttonClicked(sender:UIButton)
    {
        
        guard let cell = sender.superview?.superview as? VendorServiceCell else {return}
        let indexPath = tableView.indexPath(for:cell)
        print("index \(indexPath?.row)")
        
        emps.remove(at: indexPath!.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath!], with: .automatic)
        tableView.endUpdates()
    }
}

