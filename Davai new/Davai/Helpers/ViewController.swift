//
//  ViewController.swift
//  Rixos
//
//  Created by Abdelrahman Badary on 3/21/18.
//  Copyright © 2018 IPMagix. All rights reserved.
//

import UIKit
import MBProgressHUD
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func showNavigationBar()  {
//        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
//        self.navigationController!.navigationBar.shadowImage = nil
//
//        self.navigationController!.navigationBar.barTintColor = UIColor.navigationBarBrown
//        self.navigationController!.navigationBar.isTranslucent = true
//
//    }
//
    func hideNavigationBar()  {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
    }
    
    func showProgressIndicator()  {
        MBProgressHUD.showAdded(to: view, animated: true)
        
    }
    
    func hideProgressIndicator()  {
        MBProgressHUD.hide(for: view, animated: true)
    }

    func showDefaultAlert(with title: String, message: String)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss".localized, style: .default, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
