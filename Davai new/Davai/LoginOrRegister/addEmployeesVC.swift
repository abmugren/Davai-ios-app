//
//  addEmployeesVC.swift
//  Davai
//
//  Created by Apple on 4/24/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import Eureka
class addEmployeesVC: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
            form
            +++
            MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
                               header: "Add Employees Here",
                               footer: ".Insert Employees.") {
                                $0.tag = "textfields"
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add New Employee"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow() {
                                        $0.placeholder = "Employee Name"
                                    }
                                }
                                $0 <<< NameRow() {
                                    $0.placeholder = "Employee Name"
                                }

            }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
