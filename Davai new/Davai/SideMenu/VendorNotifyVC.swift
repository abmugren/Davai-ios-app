//
//  VendorNotifyVC.swift
//  Davai
//
//  Created by Mac on 5/22/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import PKHUD
import SDWebImage

class VendorNotifyVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    var venNotifications : [Notifications] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getNotify()
        // Do any additional setup after loading the view.
    }
    private func getNotify(){
        if CheckInternet.Connection(){
            HUD.show(.progress)
            let vendorId = Helper.getFromUserDefault(key: "clientId")
            WebService.instance.allVendorNotifications(id: vendorId ?? "") { (data) in
                HUD.hide()
                self.venNotifications = data
                self.tableView.reloadData()
                print("data",data)
            }
        }
        else{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Connection".localized))
        }
    }
//    private func setBtnMenu(){
//            if APPLANGUAGE == "ar"{
//                if revealViewController() != nil {
//                    btnMenu.target = revealViewController()
//                    btnMenu.action = #selector(SWRevealViewController().rightRevealToggle(_:))
//                    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//                    self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
//                }
//            }
//            else{
//                if revealViewController() != nil {
//                    btnMenu.target = revealViewController()
//                    btnMenu.action = #selector(SWRevealViewController().revealToggle(_:))
//                    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//                    self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
//                }
//            }
//    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venNotifications.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VendorNotifyCell
        let Notify = self.venNotifications[indexPath.row]
        cell.notifyTitle.text = Notify.title!
        cell.notifyMessage.text = Notify.text!
        cell.NotifyDate.text = String(Notify.date!.prefix(10))
        cell.notifyImage.sd_setImage(with: URL(string: Notify.logoPath!), placeholderImage: UIImage(named: "AXP"))
        return cell
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
