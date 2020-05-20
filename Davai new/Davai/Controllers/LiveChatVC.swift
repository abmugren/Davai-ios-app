
//
//  LiveChatVC.swift
//  Davai
//
//  Created by Apple on 2/7/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import SocketIO
import PKHUD

class LiveChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextViewDelegate {

    @IBOutlet weak var btnSend: GradientButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtChat: UITextView!

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var textContainer: UIView!
    let clientCover = Helper.getFromUserDefault(key: "clientCover")
    let placeId = Helper.getFromUserDefault(key: "placeId")
    let clientID = Helper.getFromUserDefault(key: "clientId")
    let userId = Helper.getFromUserDefault(key: "userId")
    var arrayOfChaltList :[ChatList]?
    var arrayOfMessages :[message]?
    var clientId :String?
    var VchatID : String?
    var selectedUserByVendor :String?
    let webService = WebService()

    override func viewDidLoad() {
        super.viewDidLoad()
        btnSend.setTitle("Send".localized, for: .normal)
        txtChat.delegate = self
        MySocket.instance.socket.connect()
       
        if clientId != ""{
            MySocket.instance.socket.on("clientReceive", callback: { (data, ack) in
                print("data lis",data)
                let messageObj = message()
                messageObj.from = 1
                messageObj.msg = data[0] as? String
                self.arrayOfMessages?.append(messageObj)
                self.tableView.reloadData()
                self.scrollToBottom()
            })
              MySocket.instance.socket.emit("joinRoom",VchatID ?? "",clientId ?? "")
        }
        else if userId != ""{
            MySocket.instance.socket.on("userReceive", callback: { (data, ack) in
                print("data lis",data)
                let messageObj = message()
                messageObj.from = 2
                messageObj.msg = data[0] as? String
                self.arrayOfMessages?.append(messageObj)
                self.tableView.reloadData()
                self.scrollToBottom()
            })
        }

        if clientCover != "" && clientCover != nil {
            coverImage.sd_setImage(with: URL(string: clientCover!), placeholderImage: UIImage(named: "AXP"))
        }
        tableView.register(UINib(nibName: "SenderCell", bundle: nil), forCellReuseIdentifier: "SenderCell")
        setupView()
         txtChat.text = "WriteyourMessage".localized
    }

    override func viewWillDisappear(_ animated: Bool) {
        MySocket.instance.socket.disconnect()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if userId != ""{ // user sign in
            self.getUserClientMessage(userID: userId ?? "", clientID: placeId ?? "")
        }
        else if selectedUserByVendor != nil {
            self.getUserClientMessage(userID: selectedUserByVendor ?? "", clientID: clientId ?? "")
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if  txtChat.text == ""{
            txtChat.text = "WriteyourMessage".localized
            txtChat.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtChat.text == "WriteyourMessage".localized{
            txtChat.text = ""
            txtChat.textColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        }
    }
    // func get user & client messages
    private func getUserClientMessage(userID:String,clientID:String){
        if CheckInternet.Connection(){
            HUD.show(.progress)

            webService.getUserHistoryChat(clientId: clientID, userId: userID) { (onSuccess, messages) in
                if onSuccess{
                    self.arrayOfMessages = messages
                    self.tableView.reloadData()
                     self.scrollToBottom()
                    HUD.hide()
                    
                }
                else{
                    HUD.flash(.labeledError(title: "Error", subtitle: "ErrorHappened".localized))
                    HUD.hide()
                }
            }

        }

        else{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Connection".localized))
        }
    }
    @IBAction func btnSendMessagePressed(_ sender: Any) {
        print("chatIddd \(self.arrayOfMessages?[0]._id ?? "")")
        //let socket = manager.defaultSocket
        if userId != ""{
            if arrayOfMessages?[0]._id != nil {
                MySocket.instance.socket.emit("startChat",self.arrayOfMessages?[0]._id  ?? "",self.txtChat.text)
                let messageObj = message()
                messageObj.from = 1
                messageObj.msg = self.txtChat.text
                self.arrayOfMessages?.append(messageObj)
                self.tableView.reloadData()
                txtChat.text = "WriteyourMessage".localized
                self.scrollToBottom()
            }
            else{
                let dic = [
                    "userID":userId ?? "","clientID":placeId ?? ""  ,"title":txtChat.text] as [String : Any]
                WebService.instance.createChatChannel(params: dic) { (onScucess, chadId) in
                    if onScucess {
                        MySocket.instance.socket.emit("startChat",chadId ?? "",self.txtChat.text)
                        let messageObj = message()
                        messageObj.from = 1
                        messageObj.msg = self.txtChat.text
                        self.arrayOfMessages?.append(messageObj)
                        self.tableView.reloadData()
                        self.txtChat.text = "WriteyourMessage".localized
                        self.scrollToBottom()
                    }
                }
            }
        }
        else {
            MySocket.instance.socket.emit("clientSend",self.txtChat.text)
            let messageObj = message()
            messageObj.from = 2
            messageObj.msg = self.txtChat.text
            self.arrayOfMessages?.append(messageObj)
            self.tableView.reloadData()
            txtChat.text = "WriteyourMessage".localized
            self.scrollToBottom()
        }
        
        MySocket.instance.socket.on("connect") {data, ack in
            print("data",data)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    func scrollToBottom(){
        let indexPath = NSIndexPath(item: (arrayOfMessages?.count ?? 1) - 1, section: 0)
        tableView.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.bottom, animated: true)
    }
    func setupView(){
        textContainer.layer.cornerRadius = 10
        textContainer.layer.borderWidth = 1
        textContainer.layer.borderColor = UIColor.darkGray.cgColor
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfMessages?.count ?? 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! chatCell
        let SenderCell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as? SenderCell
        let message = arrayOfMessages?[indexPath.row]
        Helper.makeImgRaduis(img:cell.chatImage)
        if message?.from == 2{
            cell.chatText.text = message?.msg
            // cell.chatImage.sd_setImage(with: URL(string: (message?.chatID.userID.personalImg ?? "")), placeholderImage: UIImage(named: "AXP"))
            return cell
        }
        else{
            SenderCell?.lblMessage.text = message?.msg

            //SenderCell?.imgSender.sd_setImage(with: URL(string: (message?.chatID.userID.personalImg ?? "")), placeholderImage: UIImage(named: "user"))
            return SenderCell!
        }
        cell.containerView.layer.borderWidth = 2
        cell.containerView.layer.cornerRadius = 10
        cell.containerView.layer.borderColor = UIColor.lightGray.cgColor

        cell.chatImage.layer.cornerRadius = 10
        cell.chatImage.layer.masksToBounds = true
        return cell
    }
}

