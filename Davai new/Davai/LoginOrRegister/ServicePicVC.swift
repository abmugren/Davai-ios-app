//
//  ServicePicVC.swift
//  Davai
//
//  Created by Apple on 4/24/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import Eureka
class ServicePicVC: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        form +++
                Section()
            <<< SwitchRow("switchRowTag"){
                $0.title = "Show message"
            }
            <<< LabelRow(){
                
                $0.hidden = Condition.function(["switchRowTag"], { form in
                    return !((form.rowBy(tag: "switchRowTag") as? SwitchRow)?.value ?? false)
                })
                $0.title = "Switch is on!"
        }
         <<< TextRow("Service Price").cellSetup { cell, row in
                cell.textField.placeholder = row.tag
            }
            <<< ButtonRow(){
                $0.title = "Multivalued Sections"
                $0.presentationMode = .segueName(segueName: "MultivaluedControllerSegue", onDismiss: nil)
        }

        
        print(form.values())
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
