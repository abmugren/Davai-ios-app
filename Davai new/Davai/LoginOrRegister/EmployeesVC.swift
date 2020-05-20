//
//  EmployeesVC.swift
//  Davai
//
//  Created by Apple on 4/25/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import PKHUD
class EmployeesVC: UIViewController {

    @IBOutlet weak var addemptext: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var emps : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        if addemptext.text != ""{
            insertNewEmp()
        }else{
            HUD.flash(.labeledError(title: "Wrong", subtitle: "Enter your employee name"), delay: 1)
        }
        
    }
    func insertNewEmp(){
        emps.append(addemptext.text!)
        let indexPath = IndexPath(row: emps.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        addemptext.text! = ""
        view.endEditing(true)
    }

}
extension EmployeesVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let empName = emps[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = empName
        return cell!
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            emps.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}

