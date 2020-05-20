//
//  myReservationsVC.swift
//  Davai
//
//  Created by Apple on 2/12/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit

class myReservationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var vendorBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var serviceBtn: UIButton!
    
    @IBOutlet weak var stackviewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var filterStack: UIStackView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var check = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupView()
    }
    
    @IBAction func filterBtn(_ sender: Any) {
        if(check == true){
            filterStack.isHidden = false
            stackviewHeight.constant = 30
            check = false
        }
        else {
            filterStack.isHidden = true
            stackviewHeight.constant = 0
            check = true
        }
    }
    
    func setupView(){
        view.ashrafGradient(colorOne: UIColor(displayP3Red: 30/255, green: 87/255, blue: 118/255, alpha: 1), colorTwo: UIColor(displayP3Red: 11/255, green: 36/255, blue: 71/255, alpha: 1))
        
        searchBar.placeholder = "SearchBar".localized
        
        statusBtn.layer.borderWidth = 2
        statusBtn.layer.cornerRadius = 10
        statusBtn.layer.borderColor = UIColor(displayP3Red: 30/255, green: 87/255, blue: 118/255, alpha: 1).cgColor
        
        categoryBtn.layer.borderWidth = 2
        categoryBtn.layer.cornerRadius = 10
        categoryBtn.layer.borderColor = UIColor(displayP3Red: 30/255, green: 87/255, blue: 118/255, alpha: 1).cgColor
        
        vendorBtn.layer.borderWidth = 2
        vendorBtn.layer.cornerRadius = 10
        vendorBtn.layer.borderColor = UIColor(displayP3Red: 30/255, green: 87/255, blue: 118/255, alpha: 1).cgColor
        
        serviceBtn.layer.borderWidth = 2
        serviceBtn.layer.cornerRadius = 10
        serviceBtn.layer.borderColor = UIColor(displayP3Red: 30/255, green: 87/255, blue: 118/255, alpha: 1).cgColor
        
        stackviewHeight.constant = 0
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! myReservationsCell
        cell.containerView.layer.cornerRadius = 10
        cell.containerView.layer.borderWidth = 2
        cell.containerView.layer.borderColor = UIColor.lightGray.cgColor
        
        cell.imageCell.layer.cornerRadius = 10
        cell.imageCell.layer.masksToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "details", sender: nil)
    }

}
