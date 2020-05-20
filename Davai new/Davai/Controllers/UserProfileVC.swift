
//
//  UserProfileVC.swift
//  Davai
//
//  Created by Apple on 4/13/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import PKHUD
import SocketIO
let manager = SocketManager(socketURL: URL(string: "http://104.248.175.110")!)
class UserProfileVC: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate{
    @IBOutlet weak var viewNotifaction: UIView!
    
    @IBOutlet weak var lblChatList: UILabel!
    @IBOutlet weak var btnSaveData: GradientButton!
    @IBOutlet weak var btnSavePass: ANCustomButton!
    @IBOutlet weak var btnSecurity: ANCustomButton!
    
    @IBOutlet weak var lblChat: UILabel!
    @IBOutlet weak var lblNotification: UILabel!
    
    @IBOutlet weak var viewChat: UIView!
    
    @IBOutlet weak var viewChatList: UIView!
    @IBOutlet weak var tableViewChat: UITableView!
    @IBOutlet weak var tableViewNotification: UITableView!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var imgUserProfile: UIImageView!
    
    @IBOutlet weak var collectionChatList: UICollectionView!
    @IBOutlet weak var txtEmail: TextField!
    @IBOutlet weak var txtMobile: TextField!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var txtNewPassword: TextField!
    
    @IBOutlet weak var lblForgetPassword: UILabel!
    @IBOutlet weak var txtReapeatPassword: TextField!
    @IBOutlet weak var txtCurrentPassword: TextField!
    @IBOutlet weak var txtcity: TextField!
    @IBOutlet weak var txtCountry: TextField!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnSendMessage: GradientButton!
    
    @IBOutlet weak var txtChat: UITextView!
    // Define variables
    var selectedVendorId = ""
    let userId = Helper.getFromUserDefault(key: "userId")
    var userProfile :UserProfile?
    var arrayOfCountries :[Country]?
    var arrayOfCities :[City]?
    var countrySelectedId :String?
    var citySelectedId :String?
    let pickerView = UIPickerView()
    var imgLogoPath :String?
    var arrayOfUserNotifications :[userNotification]?
    var arrayOfChaltList :[ChatList]?
    var arrayOfMessages :[message]?
    var clientId :String?
    var backButton = UIBarButtonItem()
    override func viewDidLoad() {
        super.viewDidLoad()
        MySocket.instance.socket.connect()
        MySocket.instance.socket.on("userReceive", callback: { (data, ack) in
            print("data lis",data)
            MySocket.instance.socket.connect()
            let messageObj = message()
            messageObj.from = 2
            messageObj.msg = data[0] as? String
            self.arrayOfMessages?.append(messageObj)
            self.tableViewChat.reloadData()
            self.scrollToBottom()
        })
        
        txtChat.delegate = self
        btnSendMessage.setTitle("Send".localized, for: .normal)
        btnSecurity.setTitle("secuirty".localized, for: .normal)
        btnSavePass.setTitle("savePass".localized, for: .normal)
        btnSaveData.setTitle("saveData".localized, for: .normal)
        lblForgetPassword.text = "forgetPass".localized
        self.title = "myProfile".localized
        tableViewChat.register(UINib(nibName: "SenderCell", bundle: nil), forCellReuseIdentifier: "SenderCell")
        lblChatList.text = "chatList".localized
        lblNotification.text = "notifications".localized
        lblChat.text = "ChatRoom".localized
        txtChat.text = "WriteyourMessage".localized
        
        lblForgetPassword.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(
            target: self, action: #selector(forgetPassword))
        lblForgetPassword.addGestureRecognizer(tap)
        stack.isHidden = true
        getUserInfo(userId: userId ?? "")
        setuptextField()
        setPickerToField(pickerView :pickerView,textField: txtCountry, title: "Countries".localized)

    }
    override func viewWillDisappear(_ animated: Bool) {
        MySocket.instance.socket.disconnect()
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
    @objc func back(sender: UIBarButtonItem) {
        if viewProfile.isHidden == true{
            viewChat.isHidden = true
            viewNotifaction.isHidden = true
            viewChatList.isHidden = true
            viewProfile.isHidden = false
            
        }
        else {
            if revealViewController() != nil {
                backButton.target = revealViewController()
                backButton.action = #selector(SWRevealViewController().revealToggle(_:))
                
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
                
            }
            navigationController?.popViewController(animated: true)
        }
    }
    // func get user notification
    private func getUserNotification(userID:String){
        if CheckInternet.Connection(){
            HUD.show(.progress)
            
            WebService.instance.getUserNotification(userId: userID) { (onSuccess, notifications) in
                if onSuccess{
                    self.arrayOfUserNotifications = notifications
                    self.tableViewNotification.reloadData()
                    HUD.hide()
                }
                else{
                    HUD.hide()
                    HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened".localized))
                }
            }
            
        }
        else{
            HUD.flash(.labeledError(title:"ERROR".localized, subtitle: "Connection".localized))
        }
    }
    
    // func get user chatlist
    private func getUserChatList(userID:String){
        if CheckInternet.Connection(){
            HUD.show(.progress)
            
            WebService.instance.getUserChatList(userId: userID) { (onSuccess, chatlist) in
                if onSuccess{
                    self.arrayOfChaltList = chatlist
                    self.collectionChatList.reloadData()
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
    func scrollToBottom(){
        let indexPath = NSIndexPath(item: (arrayOfMessages?.count ?? 1) - 1, section: 0)
        tableViewChat.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.bottom, animated: true)
    }
    @IBAction func btnSendPressed(_ sender: Any) {
        MySocket.instance.socket.emit("startChat",arrayOfMessages?[0]._id ?? "",self.txtChat.text)
        let messageObj = message()
        messageObj.from = 1
        messageObj.msg = self.txtChat.text
        self.arrayOfMessages?.append(messageObj)
        self.tableViewChat.reloadData()
        txtChat.text = "WriteyourMessage".localized
        self.scrollToBottom()
    }
    // func get user & client messages
    private func getUserClientMessage(userID:String,clientID:String){
        if CheckInternet.Connection(){
            HUD.show(.progress)
            
            WebService.instance.getUserHistoryChat(clientId: clientID, userId: userID) { (onSuccess, messages) in
                if onSuccess{
                    self.arrayOfMessages = messages
                    self.tableViewChat.reloadData()
                    self.scrollToBottom()
                    HUD.hide()
                }
                else{
                    HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Error Happened".localized))
                    HUD.hide()
                }
            }
        }
            
        else{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Connection".localized))
        }
    }
    @objc func forgetPassword(sender:UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "Addemail".localized, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enteryouremail".localized
        }
        let saveAction = UIAlertAction(title: "Send".localized, style: UIAlertActionStyle.default, handler: { alert -> Void in
            let emailTextField = alertController.textFields![0] as UITextField
            var isEmail = false
            isEmail =  Validate.isValidEmail(testStr: emailTextField.text ?? "")
            if emailTextField.text == nil || emailTextField.text == ""{
                HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Enteryouremail".localized), delay: 1.5)
            }
            else if isEmail == false {
                HUD.flash(.labeledError(title:"ERROR".localized, subtitle: "Enteryouremail".localized), delay: 1.5)
            }
            else{
                if CheckInternet.Connection(){
                    HUD.show(.progress)
                    WebService.instance.forgetPassword(email: emailTextField.text!) { (onSuccess, done) in
                        if onSuccess{
                            if done {
                                HUD.hide()
                                self.view.makeToast("succefully", duration: 2.0, position: .center)
                                //HUD.hide()
                            }
                            else{
                                HUD.hide()
                                HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "emailExistance".localized), delay: 1.5)
                                
                            }
                        }
                        else{
                            HUD.hide()
                            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened".localized), delay: 1.5)
                            
                        }
                    }
                }
                else{
                    HUD.flash(.labeledError(title: "Wrong", subtitle: "check your data connection"), delay: 1.5)
                    HUD.hide()
                }
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        print("tap working")
    }
    // MARK:- TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtCountry {
            HUD.show(.progress)
            WebService.instance.getCountries { (onSuccess, countries) in
                if onSuccess {
                    self.arrayOfCountries = countries
                    print("countnt \(self.arrayOfCountries?.count)")
                    self.pickerView.reloadAllComponents()
                    HUD.hide()
                }
                else{
                    HUD.hide()
                }
            }
        }
        else if textField == txtcity {
            
            if countrySelectedId == nil || txtCountry.text == ""{
                HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "chooseCountry".localized))
            }
            else {
                setPickerToField(pickerView:pickerView ,textField: txtcity, title: "Cities".localized)
                HUD.show(.progress)
                WebService.instance.getCities(countryId: countrySelectedId!) { (onSuccess, cities) in
                    if onSuccess{
                        self.arrayOfCities = cities
                        self.pickerView.reloadAllComponents()
                        HUD.hide()
                    }
                    else{
                        HUD.hide()
                    }
                }
            }
        }
    }
    // MARK:- setup PickerView
    private func setuptextField(){
        txtCountry.delegate = self
        txtcity.delegate = self
    }
    // MARK:- GET_USER_INFO
    private func getUserInfo(userId :String){
        if CheckInternet.Connection(){
            HUD.show(.progress)
            
            WebService.instance.getUSerProfile(userId: userId) { (onSuccess, userProfile) in
                if onSuccess{
                    self.userProfile = userProfile
                    self.setupUser(user: userProfile!)
                    
                    HUD.hide()
                }
                else{
                    HUD.hide()
                    HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened".localized))
                }
            }
        }
        else{
            HUD.hide()
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Connection".localized))
        }
    }
    private func setupUser(user:UserProfile){
        txtcity.text = user.cityID.titleEN
        txtEmail.text = user.email
        txtMobile.text = user.mobile
        txtCountry.text = user.countryID.titleEN
        Helper.circleImg(image: imgUserProfile)

        imgUserProfile?.sd_setImage(with: URL(string: (user.personalImg ?? "")), placeholderImage: UIImage(named: "user"))
        lblUserName.text = "\(user.firstName) \(user.lastName ?? "")"
    }
    @IBAction func btnSavePressed(_ sender: Any) {
    }
    @IBAction func btnCameraPressed(_ sender: Any) {
        let imagepickercontroller = UIImagePickerController()
        imagepickercontroller.delegate = self
        let actionsheet = UIAlertController(title: "Maxiumum".localized, message: "ChooseASource".localized, preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Camera".localized, style: .default, handler: { (action:UIAlertAction) in
            imagepickercontroller.sourceType = .camera
            self.present(imagepickercontroller, animated: true, completion: nil)
        }))
        actionsheet.addAction(UIAlertAction(title: "Photolibrary".localized, style: .default, handler: { (action:UIAlertAction) in
            imagepickercontroller.sourceType = .photoLibrary
            self.present(imagepickercontroller, animated: true, completion: nil)
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        self.present(actionsheet, animated: true, completion: nil)
        
    }
    ////// MARK:- ImgPicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        WebService.instance.uploadThumbnail(thumbnail: image, completionHandler: { (sucess, response, error) in
            if sucess {
                print(response)
                HUD.flash(.success, delay: 2.0)
                self.imgLogoPath = response as? String
                print("imgPathLogo \(String(describing: self.imgLogoPath))")
                
            } else {
                print("error")
            }
        })
    }
    // MARK:- ImgPicker Cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnChatPressed(_ sender: Any) {
        viewProfile.isHidden = true
        viewNotifaction.isHidden = true
        viewChat.isHidden = true
        viewChatList.isHidden = false
        getUserChatList(userID: userId ?? "")
    }
    @IBAction func btnNotificationPressed(_ sender: Any) {
        viewProfile.isHidden = true
        viewChat.isHidden = true
        viewChatList.isHidden = true
        viewNotifaction.isHidden = false
        
        getUserNotification(userID: userId ?? "")
    }
    
    @IBAction func btnSaveDataPressed(_ sender: Any) {
        var isEmail = false
        var isPhone = false
        
        isPhone = Validate.isValidatePhone(value:txtMobile.text ?? "")
        isEmail =  Validate.isValidEmail(testStr: txtEmail.text ?? "")
        
        if self.txtcity.text == nil || self.txtcity.text == ""{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "validCity".localized), delay: 1.5)
        }
        else if !isPhone{
            HUD.flash(.labeledError(title:"ERROR".localized, subtitle: "Entervalidphonenumber".localized), delay: 1.5)
        }
        else if !isEmail{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "entervalidateemail".localized), delay: 1.5)
        }
        else if (self.txtCountry.text?.isEmpty)! || self.txtCountry.text == ""{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "chooseCountry".localized), delay: 1.5)
        }
        else if (self.txtMobile.text?.isEmpty)! || self.txtMobile.text == ""{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Entervalidphonenumber".localized), delay: 1.5)
        }
        else if (self.txtEmail.text?.isEmpty)! || self.txtEmail.text == ""{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "entervalidateemail".localized), delay: 1.5)
        }
        else{
            HUD.show(.progress)
            var dic = ["mobile":txtMobile.text,"email":txtEmail.text] as? [String:String]
            if countrySelectedId != nil &&  citySelectedId != nil{
                dic = ["mobile":txtMobile.text,"email":txtEmail.text,"countryID":countrySelectedId,"cityID":citySelectedId] as? [String:String]
            }
            else if citySelectedId != nil{
                dic = ["mobile":txtMobile.text,"email":txtEmail.text,"cityID":citySelectedId] as? [String:String]
            }
            else if countrySelectedId != nil {
                dic = ["mobile":txtMobile.text,"email":txtEmail.text,"countryID":countrySelectedId] as? [String:String]
            }
            else if imgLogoPath != nil {
                dic?["personalImg"] = imgLogoPath!
            }
            WebService.instance.updateProfile(params:dic!,userId: userId ?? "") { (onSuccess, user) in
                if onSuccess{
                    HUD.hide()
                    self.view.makeToast("succefully", duration: 2.0, position: .center)
                }
                else{
                    HUD.hide()
                    self.setupUser(user: self.userProfile!)
                    HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened".localized), delay: 1.5)
                    
                }
            }
        }
    }
    @IBAction func btnSecuirtPressed(_ sender: Any) {
        if stack.isHidden == true{
            stack.isHidden = false
        }
        else {
            stack.isHidden = true
        }
    }
    
    @IBAction func btnSavePassword(_ sender: Any) {
        if userProfile?.password == txtCurrentPassword.text && txtNewPassword.text == txtReapeatPassword.text && txtNewPassword.text?.count ?? 1 >= 6 {
            let dic = ["password":txtNewPassword.text] as? [String:String]
            HUD.show(.progress)
            WebService.instance.updateProfile(params:dic!,userId: userId ?? "") { (onSuccess, user) in
                if onSuccess{
                    HUD.hide()
                    self.view.makeToast("succefully", duration: 2.0, position: .center)
                    self.txtCurrentPassword.text = ""
                    self.txtNewPassword.text = ""
                    self.txtReapeatPassword.text = ""
                }
                else{
                    HUD.hide()
                    self.txtCurrentPassword.text = ""
                    self.txtNewPassword.text = ""
                    self.txtReapeatPassword.text = ""
                    HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened".localized), delay: 1.5)
                }
            }
            
        }
        else if userProfile?.password != txtCurrentPassword.text{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "passwordCorrectness".localized), delay: 2)
            self.txtCurrentPassword.text = ""
        }
        else if txtNewPassword.text != txtReapeatPassword.text {
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "MatchPass".localized), delay: 2)
            self.txtNewPassword.text = ""
            self.txtReapeatPassword.text = ""
        }
        else if txtNewPassword.text?.count ?? 1 < 6 {
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "validatePassword".localized), delay: 3)
            self.txtNewPassword.text = ""
            self.txtReapeatPassword.text = ""
        }
    }
    
    // End of the calss
}
// Extenion
extension UserProfileVC{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfChaltList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! userChatCell
        let obj = arrayOfChaltList?[indexPath.row]
        
        cell.lblName.text = obj?.clientID.brandName
        cell.imgChatItem.sd_setImage(with: URL(string: (obj?.clientID.logo ?? "")), placeholderImage: UIImage(named: "AXP"))
        
        cell.contentView.layer.cornerRadius = 30
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  5
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/3.2, height: collectionViewSize/3.2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewProfile.isHidden = true
        viewChatList.isHidden = true
        viewNotifaction.isHidden = true
        viewChat.isHidden = false
        getUserClientMessage(userID: userId ?? "", clientID: (arrayOfChaltList?[indexPath.row].clientID._id)! )
        selectedVendorId = arrayOfChaltList?[indexPath.row].clientID._id ?? ""
//        clientId = arrayOfChaltList?[indexPath.row].clientID._id
        print("idd \(clientId)")
        
    }
}
// MARK:_  Fill PickerView
extension UserProfileVC{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag ==  1{
            return (arrayOfCountries?.count) ?? 2
        }
        else if pickerView.tag == 2{
            return (arrayOfCities?.count) ?? 2
        }
        else {
            return 1
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag ==  1{
            if APPLANGUAGE == "en"{
                return arrayOfCountries?[row].titleEN
            }
            else{
                return arrayOfCountries?[row].titleAr
            }
            
        }
        else if pickerView.tag == 2{
            if APPLANGUAGE == "en"{
                 return arrayOfCities?[row].titleEN
            }
            else{
                 return arrayOfCities?[row].titleAr
            }
        }
        else {
            return "default"
        }
    }
    // didSelect
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag ==  1 {
            if APPLANGUAGE == "en"{
                txtCountry.text = arrayOfCountries?[row].titleEN
                countrySelectedId = arrayOfCountries?[row].countryID
            }
            else{
                txtCountry.text = arrayOfCountries?[row].titleAr
                countrySelectedId = arrayOfCountries?[row].countryID
            }
            
        }
        else if pickerView.tag == 2{
            if APPLANGUAGE == "en"{
                txtcity.text = arrayOfCities?[row].titleEN
                citySelectedId = arrayOfCities?[row].cityID
            }
            else{
                txtcity.text = arrayOfCities?[row].titleAr
                citySelectedId = arrayOfCities?[row].cityID
            }
            
        }
    }
}
extension UserProfileVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewNotification{
            return arrayOfUserNotifications?.count ?? 1
        }
        else {
            return arrayOfMessages?.count ?? 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewNotification{
            let cell = tableView.dequeueReusableCell(withIdentifier: "userNotifactionCell", for: indexPath) as? userNotifactionCell
            let obj = arrayOfUserNotifications?[indexPath.row]
            cell?.lblMessage.text = obj?.msg
            cell?.lblDate.text = String(obj?.createdAt?.prefix(10) ?? "")
            cell?.lblVendorName.text = obj?.clientID.brandName
            cell?.imgUserNotification?.sd_setImage(with: URL(string: (obj?.userID?.personalImg ?? "")), placeholderImage: UIImage(named: "AXP"))
            return cell!
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? chatCell
            let SenderCell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as? SenderCell
            let message = arrayOfMessages?[indexPath.row]
            
            if message?.from == 2{
                cell?.chatText.text = message?.msg
                //cell?.chatImage.sd_setImage(with: URL(string: (message?.userID.personalImg ?? "")), placeholderImage: UIImage(named: "AXP"))
                return cell!
            }
            else{
                SenderCell?.lblMessage.text = message?.msg
                //SenderCell?.imgSender.sd_setImage(with: URL(string: (message?.chatID.userID.personalImg ?? "")), placeholderImage: UIImage(named: "user"))
                return SenderCell!
            }
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewChat{
            
        }
    }
}
