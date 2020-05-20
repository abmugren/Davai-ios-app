//
//  LoginOrRegisterVC.swift
//  Davai
//
//  Created by MacBook  on 1/29/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import GoogleSignIn
import  TwitterKit
import  PKHUD
import Alamofire

class LoginOrRegisterVC: UIViewController ,GIDSignInUIDelegate,GIDSignInDelegate{
    
	
	@IBOutlet weak var bookingLabel: UILabel!
	@IBOutlet weak var signInWithLabel: UILabel!
	
    @IBOutlet weak var signinwith: UILabel!
    @IBOutlet weak var orTitle: UILabel!
    @IBOutlet weak var orLabel: UILabel!
	@IBOutlet weak var signUpBtn: UIButton!
	@IBOutlet weak var signInBtn: UIButton!
	@IBOutlet weak var skipLoginBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
     @IBOutlet weak var googleSignIn: GIDSignInButton!
    var userName :String = ""
    var user:User?
    var firstName :String?
    var lastName :String?
    
	override func viewDidLoad() {
        
        

		super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 32/255, green: 60/255, blue: 82/255, alpha: 1)
        navigationItem.title = "Menu"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        GIDSignIn.sharedInstance().delegate = self
         GIDSignIn.sharedInstance().uiDelegate = self
//        let colors: [UIColor] = [#colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1),#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)]
//        navigationController?.navigationBar.setGradientBackground(colors: colors)
		
		setUpViews()
        skipLoginBtn.setTitle("skip".localized, for: .normal)
        signUpBtn.setTitle("signup".localized, for: .normal)
        signInBtn.setTitle("signin".localized, for: .normal)
        orTitle.text = "orTitle".localized
        signinwith.text = "signinwith".localized
	}
    
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	@IBAction func signInAction(_ sender: Any) {
		let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        navigationController?.pushViewController(vc, animated: true)
	}
	
    @IBAction func socialSignIn(_ sender: Any) {
        if CheckInternet.Connection() {
            if (sender as AnyObject).tag == 5{
                
                let loginManager=LoginManager()
                loginManager.logIn(readPermissions: [ReadPermission.publicProfile], viewController : self) { loginResult in
                    switch loginResult {
                    case .failed(let error):
                        print(error)
                    case .cancelled:
                        print("User cancelled login")
                    case .success(let _):
                        print("Logged in")
                        self.getFBUserData()
                    }
             }
                
            }
            else if (sender as AnyObject).tag == 7{
                HUD.show(.progress)
                GIDSignIn.sharedInstance()?.signIn()
                GIDSignIn.sharedInstance().delegate = self
                GIDSignIn.sharedInstance().uiDelegate = self
                GIDSignIn.sharedInstance().signIn()
                HUD.hide()
            }
            else if (sender as AnyObject).tag == 6{
                //            ////
                 HUD.show(.progress)
                TWTRTwitter.sharedInstance().logIn { (session, error) in
                    if (session != nil) {
                        self.firstName = session?.userName ?? ""
                        self.lastName = session?.userName ?? ""
                        let client = TWTRAPIClient.withCurrentUser()
                        client.requestEmail { email, error in
                            if (email != nil) {
                                self.getUserInfo()
                                HUD.hide()
                            }else {
                                HUD.hide()
                                print("error: \(String(describing: error?.localizedDescription))");
                            }
                        }
                    }else {
                         HUD.hide()
                        print("error: \(String(describing: error?.localizedDescription))");
                    }
                }
            }
        }
        else {
            HUD.flash(.labeledError(title: "Wrong", subtitle: "Check your data connection"), delay: 1.5)
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
		let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        navigationController?.pushViewController(vc, animated: true)
	}
	
	
	func setUpViews(){
		signInBtn.layer.borderWidth = 2
		signInBtn.layer.cornerRadius = 20
		signInBtn.layer.borderColor = UIColor.white.cgColor
	}
    
    @IBAction func skipLogin(_ sender: Any) {
        Helper.saveInUserDefault(value: "skip", key: "userType")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MyTabBarController") as! MyTabBarController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = mainViewController
        appDelegate.window?.makeKeyAndVisible()
        
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
    //MARK:- Sigue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let signUpVC = segue.destination as? SignUpVC
        {
            if (segue.identifier == "signUp") {
                signUpVC.user = self.user
            }
        }
        if let signInVC = segue.destination as? SignInVC
        {
            if (segue.identifier == "fromFbToSignIn") {
                signInVC.emailStr = userName
            }
        }
    }
}



extension LoginOrRegisterVC{
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            let request = GraphRequest.init(graphPath: "me", parameters: ["fields": "id, email, name, first_name, last_name, age_range, birthday, link, gender, locale, timezone, picture, updated_time, verified"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
            
            request.start({ (response, requestResult) in
                switch requestResult{
                case .success(let response):
                    print("ress \(response)")
                    
                    self.userName = response.dictionaryValue!["email"] as? String ?? ""
                    let name = response.dictionaryValue!["name"] as? String ?? ""
                    let firstName = response.dictionaryValue!["first_name"] as? String ?? ""
                    let lastName = response.dictionaryValue!["last_name"] as? String ?? ""
                    let image = response.dictionaryValue!["picture"] as? String ?? ""
                    print("email \(self.userName)")
                    Helper.saveInUserDefault(value: self.userName  ?? "" , key: "email")
                    Helper.saveInUserDefault(value:firstName ?? "" , key: "firstName")
                    Helper.saveInUserDefault(value:lastName ?? "" , key: "lastName")
                    
                    self.user = User.init(email: self.userName, firstName: firstName, lastName: lastName)
                    WebService.instance.checkEmailExist(email: self.userName, completion: { (onSuccess, exist, user) in
                        if onSuccess {
                            if exist == false{
                                print("non exist")
                                 HUD.hide()
                                self.performSegue(withIdentifier: "signUp", sender: nil)
                            }
                            else{
                                HUD.hide()
                                self.performSegue(withIdentifier: "fromFbToSignIn", sender: nil)
                            }
                        }
                        else {
                            HUD.hide()
                        }
                    })
    
                case .failed(let error):
                    HUD.hide()
                    print(error.localizedDescription)
                }
            })
        }
    }
    
}
extension LoginOrRegisterVC{
    func getUserInfo(){
        if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID: userID)
            let url = "https://api.twitter.com/1.1/users/show.json"
            var clientError : NSError?
            let request = client.urlRequest(withMethod: "GET",
                                            urlString: "https://api.twitter.com/1.1/account/verify_credentials.json?include_email=true",
                                            parameters: ["include_email": "true", "skip_status": "true"],error: nil)
            
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if let someData = data {
                    do {
                        let results = try JSONSerialization.jsonObject(with: someData, options: .allowFragments) as! NSDictionary
                        let firstName = results["name"] as? String
                        let email = results["email"] as? String
                        self.user = User.init(email: email ?? "", firstName: firstName ?? "" , lastName: "")
                        Helper.saveInUserDefault(value:email ?? "" , key: "email")
                        self.userName = email ?? ""
                        Helper.saveInUserDefault(value:firstName ?? "" , key: "firstName")
                       // Helper.saveInUserDefault(value:familyName ?? "" , key: "lastName")
                        WebService.instance.checkEmailExist(email: email ?? "", completion: { (onSuccess, exist, user) in
                            if onSuccess {
                                if exist == false{
                                    HUD.hide()
                                    print("non exist")
                                    
                                    self.performSegue(withIdentifier: "signUp", sender: nil)
                                }
                                else{
                                    HUD.hide()
                                    self.performSegue(withIdentifier: "fromFbToSignIn", sender: nil)
                                }
                            }
                            else {
                                HUD.hide()
                            }
                        })
                    } catch {
                    }
                }
                if connectionError != nil{
                    HUD.hide()
                }
            }
        }
    }
}
///
extension LoginOrRegisterVC{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        HUD.hide()
        if let error = error {
            print("\(error.localizedDescription)")
            // [START_EXCLUDE silent]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
            // [END_EXCLUDE]
        } else {
            HUD.hide()
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            Helper.saveInUserDefault(value:email ?? "" , key: "email")
            Helper.saveInUserDefault(value:givenName ?? "" , key: "firstName")
            Helper.saveInUserDefault(value:familyName ?? "" , key: "lastName")
            //print("emaillllll \(email)")
            self.user = User.init(email: self.userName, firstName: givenName ?? "", lastName: familyName ?? "" )
            WebService.instance.checkEmailExist(email: email ?? "", completion: { (onSuccess, exist, user) in
                if onSuccess {
                    if exist == false{
                        print("non exist")
                        HUD.hide()
                        self.performSegue(withIdentifier: "signUp", sender: nil)
                    }
                    else{
                        HUD.hide()
                        self.performSegue(withIdentifier: "fromFbToSignIn", sender: nil)
                    }
                }
                else {
                    HUD.hide()
                }
            })
            
            // [START_EXCLUDE]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"),
                object: nil,
                userInfo: ["statusText": "Signed in user:\n\(fullName)"])
        }
    }
    
    

}
