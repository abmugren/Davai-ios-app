//
//  PickerVC.swift
//  Davai
//
//  Created by MacBook  on 2/3/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit

class PickerVC: ViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var doneBtn: UIButton!
	@IBOutlet weak var closeBtn: UIImageView!
	@IBOutlet weak var containerView: UIView!
	
    @IBOutlet weak var titleLabel: UILabel!
    var arrayOfCategories :[Category]?
    var seletedCategoryRow :Int?
    // making this a weak variable so that it won't create a strong reference cycle
    weak var delegatee: PassDatadDelegate? = nil
    
	override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
        titleLabel.text = "chooseS".localized
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
		closeBtn.isUserInteractionEnabled = true
		closeBtn.addGestureRecognizer(tapGestureRecognizer)
		
		setupView()
    }
    // MARK:- Performe Sigue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let VendorSignUpVC = segue.destination as? SignUpVendorVC
        {
            if (segue.identifier == "") {
                VendorSignUpVC.selectedCategoryRow = seletedCategoryRow
            }
        }
    }
	func setupView(){
		containerView.layer.borderWidth = 2
		containerView.layer.borderColor = UIColor.lightGray.cgColor
		
		doneBtn.layer.borderWidth = 2
		doneBtn.layer.borderColor = UIColor.white.cgColor
	}
	
	@objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
		dismiss(animated: true, completion: nil)
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCategories?.count ?? 1
	}
	
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! categoryCell
        cell.countryName.text = arrayOfCategories?[indexPath.row].titleEN
		cell.textLabel?.textAlignment = .center
		return cell
	}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegatee?.userDidEnterInformation(row: indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }

}


// protocol used for sending data back
protocol PassDatadDelegate: class {
    func userDidEnterInformation(row: Int)
}
