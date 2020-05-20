//
//  Extensions.swift
//  Davai
//
//  Created by MacBook  on 1/29/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit

@IBDesignable
class GradientButton: UIButton {
	let gradientLayer = CAGradientLayer()
	
	@IBInspectable
	var topGradientColor: UIColor? {
		didSet {
			
			gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
			gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
			setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
			
		}
	}
	
	@IBInspectable
	var bottomGradientColor: UIColor? {
		didSet {
			setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
		}
	}
	
	
	
	 func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
		if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
			gradientLayer.frame = bounds
			gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
			gradientLayer.borderColor = layer.borderColor
			gradientLayer.borderWidth = layer.borderWidth
			gradientLayer.cornerRadius = layer.cornerRadius
			layer.insertSublayer(gradientLayer, at: 0)
		} else {
			gradientLayer.removeFromSuperlayer()
		}
	}
}

class TextField: UITextField {
	
	let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5);
	
	override open func textRect(forBounds bounds: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(bounds, padding)
	}
	
	override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(bounds, padding)
	}
	
	override open func editingRect(forBounds bounds: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(bounds, padding)
	}
}

extension UIView {
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
}

class GradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [UIColor(displayP3Red: 30/255, green: 87/255, blue: 118/255, alpha: 1).cgColor, UIColor(displayP3Red: 11/255, green: 36/255, blue: 71/255, alpha: 1).cgColor]
    }
}

class AshrafGradient: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [UIColor(displayP3Red: 11/255, green: 36/255, blue: 71/255, alpha: 1).cgColor, UIColor(displayP3Red: 30/255, green: 87/255, blue: 118/255, alpha: 1).cgColor]
        
        
    }
}
public func localizedSitringFor(key:String)->String {
    return NSLocalizedString(key, comment: "")
}


extension UIView {
    func ashrafGradient(colorOne: UIColor, colorTwo: UIColor){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
}

extension String {
    var localized: String {
        return localizedSitringFor(key: self)
    }
}


extension UIViewController {
    
    
    func setPickerToField(pickerView :UIPickerView ,textField: UITextField , title: String){
        
        pickerView.delegate = self as? UIPickerViewDelegate
        pickerView.dataSource = self as? UIPickerViewDataSource
        pickerView.tag = textField.tag
        textField.inputView = pickerView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        
        toolBar.tintColor = UIColor.white
        
        toolBar.backgroundColor = UIColor.black
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 12)
        
        label.backgroundColor = UIColor.clear
        
        label.textColor = UIColor.white
        
        label.text = title
        
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        textField.inputAccessoryView = toolBar
        
    }
    
    @objc func donePressed(_ sender: UIBarButtonItem) {
        
        self.view.endEditing(true)
        
    }
    //
    func setTimePickerToField(pickerView :UIDatePicker ,textField: UITextField , title: String){
        
//        pickerView.delegate = self as? UIDatePickerDelegate
//        pickerView.dataSource = self as? UIDatePickerDataSource
        pickerView.tag = textField.tag
        textField.inputView = pickerView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        
        toolBar.tintColor = UIColor.white
        
        toolBar.backgroundColor = UIColor.black
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 12)
        
        label.backgroundColor = UIColor.clear
        
        label.textColor = UIColor.white
        
        label.text = title
        
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        textField.inputAccessoryView = toolBar
        
    }
    
}


