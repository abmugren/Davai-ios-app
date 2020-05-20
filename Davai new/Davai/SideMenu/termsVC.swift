//
//  aboutDavaiVC.swift
//  Davai
//
//  Created by Apple on 2/6/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import PKHUD

class termsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    
    var arrayOfAbout :[About]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //menuButton.title = "menu".localized
        let backImg: UIImage = UIImage(named: "side20")!
        
        tableView.layer.borderWidth = 2
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.cornerRadius = 10
        if UserDefaults.standard.string(forKey: "userType") == "user"{
            getAbout(type: "userAbout")
        }
        else if UserDefaults.standard.string(forKey: "userType") == "vendor"{
            getAbout(type: "clientAbout")
        }
        else {
            getAbout(type: "userAbout")
        }
        

    }
    private func getAbout(type :String){
        if CheckInternet.Connection(){
            HUD.show(.progress)
            WebService.instance.getAbout(type: type) { (onSuccess, abouts) in
                if onSuccess{
                    self.arrayOfAbout = abouts
                    self.tableView.reloadData()
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
    }
    func setupView(){
        navigationItem.title = "TermsConditions".localized
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.cornerRadius = 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfAbout?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aboutCell", for: indexPath) as! aboutCell
        cell.aboutLabel.text = arrayOfAbout?[indexPath.row].titleEN
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
}





