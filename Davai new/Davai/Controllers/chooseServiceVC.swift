//
//  chooseServiceVC.swift
//  Davai
//
//  Created by Apple on 2/13/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit

class chooseServiceVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! chooseServiceCell
        
        cell.serviceTF.attributedPlaceholder = NSAttributedString(string: "Face Masks",
                                                                  attributes: [NSAttributedStringKey.foregroundColor: UIColor(displayP3Red: 30/255, green: 87/255, blue: 118/255, alpha: 1)])
        
        cell.serviceTF.layer.borderColor = UIColor(displayP3Red: 30/255, green: 87/255, blue: 118/255, alpha: 1).cgColor
        cell.serviceTF.layer.borderWidth = 2
        
        

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "details", sender: nil)
    }
    
}
