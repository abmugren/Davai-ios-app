//
//  creatsAdsVC.swift
//  Davai
//
//  Created by Apple on 2/18/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import CLabsImageSlider
import PKHUD

class creatsAdsVC: UIViewController ,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var btnMenu: UIBarButtonItem!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var btnSend: ANCustomButton!
    @IBOutlet weak var sliderView: CLabsImageSlider!
    @IBOutlet weak var adsView: UIImageView!
    @IBOutlet weak var uploadImageView: UIView!
    @IBOutlet weak var reserveAdsView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var uploadAdsButton: UIButton!
    @IBOutlet weak var imageSizeLabel: UILabel!
    @IBOutlet weak var adsDesc: UILabel!
    @IBOutlet weak var titleCost: UILabel!
    @IBOutlet weak var btnMoney: UIButton!
    @IBOutlet weak var btnPaay: UIButton!
    @IBOutlet weak var adsDays: UIButton!
    
    
     var clientId :String = Helper.getFromUserDefault(key: "clientId") ?? ""
    var arrayOfAds :[Ads]?
    var arrayOfSliderImages :[String] = []
    var impPath:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = "adsTitle".localized
        lblDetails.text = "adsDetails".localized
        uploadAdsButton.setTitle("adsBtn".localized, for: .normal)
        imageSizeLabel.text = "size".localized
        adsDays.setTitle("daays".localized, for: .normal)
        adsDesc.text = "limit".localized
        titleCost.text = "spent".localized
        btnMoney.setTitle("mony".localized, for: .normal)
        btnPaay.setTitle("paaay".localized, for: .normal)
//        btnSend.setTitle("btnSend".localized, for: .normal)
//        setBtnMenu()
//        txtDescription.delegate = self
//        //setupView()
//        txtDescription.text = "WriteyourDescription".localized
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if  txtDescription.text == ""{
            txtDescription.text = "WriteyourDescription".localized
            txtDescription.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtDescription.text == "WriteyourDescription".localized{
            txtDescription.text = ""
            txtDescription.textColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        }
    }
    ///
    ////// MARK:- ImgPicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        WebService.instance.uploadThumbnail(thumbnail: image, completionHandler: { (sucess, response, error) in
            if sucess {
                HUD.flash(.success, delay: 2.0)
                
                self.impPath = response as? String
                    print("imgPathLogo \(String(describing: self.impPath))")
             
            } else {
                print("error")
            }
        })
    }
    // MARK:- ImgPicker Cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnUpload(_ sender: Any) {
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
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionsheet, animated: true, completion: nil)
    }
    
    @IBAction func btnCreateAds(_ sender: Any) {
        if impPath == nil {
                HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "uplaodAdsImagefirstly".localized), delay: 1.5)
        }
         else if  self.txtDescription.text.count  < 6  {
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "validDescription".localized), delay: 1.5)
        }
        else if self.txtDescription.text == "WriteyourDescription".localized{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "WriteyourDescription".localized), delay: 1.5)
        }
        else {
            let dic = ["imgPath":impPath ?? "" ,"clientID":clientId,"description":txtDescription.text] as? [String : Any] ?? [:]
            WebService.instance.createAds(params: dic) { (onSucess, created) in
                if onSucess{
                    self.impPath = nil
                    self.txtDescription.text = "WriteyourDescription".localized
                    self.txtDescription.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                    HUD.flash(.success, delay: 1.5)
                }
            }
        }
     
     
    }
    
    override func viewDidLayoutSubviews() {
//        WebService.instance.getAds { (onSuccess, ads) in
//            if onSuccess{
//                self.arrayOfAds = ads
//                for item in self.arrayOfAds!{
//                    self.arrayOfSliderImages.append(item.imgPath)
//                }
//
//                self.sliderView.setUpView(imageSource: .Url(imageArray:self.arrayOfSliderImages,placeHolderImage:UIImage(named:"Favorite")),slideType:.Automatic(timeIntervalinSeconds: 2.0),isArrowBtnEnabled: true)
//            }
//        }
        
    }
    private func setBtnMenu(){
        if APPLANGUAGE == "ar"{
            if revealViewController() != nil {
                btnMenu.target = revealViewController()
                btnMenu.action = #selector(SWRevealViewController().rightRevealToggle(_:))
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            }
        }
        else{
            if revealViewController() != nil {
                btnMenu.target = revealViewController()
                btnMenu.action = #selector(SWRevealViewController().revealToggle(_:))
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            }
        }
    }
    func setupView(){
        
        navigationItem.title = "CreateAds".localized
        adsView.layer.cornerRadius = 10
        adsView.layer.masksToBounds = true
        
        uploadImageView.layer.borderWidth = 1
        reserveAdsView.layer.borderWidth = 1
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 10
    }
    
}
