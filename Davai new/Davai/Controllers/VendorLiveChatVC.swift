//
//  VendorLiveChatVC.swift
//  Davai
//
//  Created by Apple on 5/8/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import PKHUD

class VendorLiveChatVC: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{

    
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var collectionChat: UICollectionView!
    var arrayChatList :[VendorChatItem]?
    let cilentId = UserDefaults.standard.string(forKey: "clientId")
     let clientCover = Helper.getFromUserDefault(key: "clientCover")
    var selectedUser :String?
    var clientId :String?
    var VchatID : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if clientCover != "" && clientCover != nil {
            imgCover.sd_setImage(with: URL(string: clientCover!), placeholderImage: UIImage(named: "AXP"))
        }
        if CheckInternet.Connection(){
            HUD.show(.progress)
            WebService.instance.getVendorChatList(clientId: cilentId ?? "") { (onSuccess, chatList) in
                if onSuccess {
                   HUD.hide()
                    self.arrayChatList = chatList
                    self.collectionChat.reloadData()
                }
                else{
                    HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened".localized), delay: 1.5)
                }
            }
        }
        else{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Connection".localized), delay: 1.5)
        }
        
    }
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let liveChatVC = segue.destination as? LiveChatVC
        {
            if (segue.identifier == "chatRoom") {
                liveChatVC.clientId = clientId ?? ""
                liveChatVC.selectedUserByVendor = selectedUser
                liveChatVC.VchatID = VchatID ?? ""
            }
        }
    }
}

// //Extenion
extension VendorLiveChatVC {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayChatList?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VendorLiveChatCell", for: indexPath) as! VendorLiveChatCell
        cell.imChatCell.image = UIImage(named: "rate")
        let obj = arrayChatList?[indexPath.row]
        cell.imChatCell?.sd_setImage(with: URL(string:(obj?.personalImg) ?? ""), placeholderImage: UIImage(named: "AXP"))
        cell.lblUserName.text = obj?.firstName
        return cell 
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        clientId = arrayChatList?[indexPath.row].clientID
        selectedUser = arrayChatList?[indexPath.row].userId
        VchatID = arrayChatList?[indexPath.row]._id
        print("beforePass \(selectedUser)")
        performSegue(withIdentifier: "chatRoom", sender: nil)
    }
}
