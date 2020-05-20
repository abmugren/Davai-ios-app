//
//  ChooseLanguageVC.swift
//  Davai
//
//  Created by MacBook  on 1/28/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit

class ChooseLanguageVC: UIViewController {
	
	@IBOutlet weak var englishButton: UIButton!
	@IBOutlet weak var arabicButton: UIButton!
	
    @IBOutlet weak var chooseApp: UILabel!
    
    
	override func viewDidLoad() {
		super.viewDidLoad()
		chooseApp.text = "chooseLang".localized
		setupButtons()
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	@IBAction func englishAction(_ sender: Any) {
        if (sender as AnyObject).tag == 1 {
            LanguageManger().changeToLanguage("en", self)
        }else{
            LanguageManger().changeToLanguage("ar", self)
        }
		performSegue(withIdentifier: "test", sender: nil)
	}
		
	func setupButtons(){
		englishButton.layer.cornerRadius = 20
		englishButton.layer.borderWidth = 2
		englishButton.layer.borderColor = UIColor.white.cgColor
		
		arabicButton.layer.cornerRadius = 20
		arabicButton.layer.borderWidth = 2
		arabicButton.layer.borderColor = UIColor.white.cgColor
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Hide the navigation bar on the this view controller
		self.navigationController?.setNavigationBarHidden(true, animated: animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		// Show the navigation bar on other view controllers
		self.navigationController?.setNavigationBarHidden(false, animated: animated)
	}
	
	
}



