//
//  EditChatVC.swift
//  Davai
//
//  Created by Apple on 2/24/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit

class EditChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textContainer: UIView!
    @IBOutlet weak var adsView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        setupView()
    }
    
    func setupView(){
        adsView.layer.cornerRadius = 15
        adsView.layer.masksToBounds = true
        tableView.separatorStyle = .none
        
        
        textContainer.layer.cornerRadius = 10
        textContainer.layer.borderWidth = 1
        textContainer.layer.borderColor = UIColor.darkGray.cgColor
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! editChatCell
        
        cell.sendText.text = "Ashraf Essam"
        
        cell.chatImage.layer.cornerRadius = 10
        cell.chatImage.layer.masksToBounds = true
        
        cell.containerView.layer.borderWidth = 2
        cell.containerView.layer.cornerRadius = 10
        cell.containerView.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
}
