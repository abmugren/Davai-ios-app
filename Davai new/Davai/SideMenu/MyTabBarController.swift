//
//  MyTabBarController.swift
//  Davai
//
//  Created by Apple on 2/7/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import Dispatch

class MyTabBarController: UITabBarController,UITabBarControllerDelegate {
    @IBOutlet weak var lblHomeMessage: UILabel!
    
    @IBOutlet weak var lblFavMessage: UILabel!
    @IBOutlet var viewFav: GradientView!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet var viewSkip: GradientView!
    var tabIndex :Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tabBar.items?[3].title = "homenav".localized
        tabBar.items?[2].title = "res".localized
        tabBar.items?[1].title = "fav".localized
        tabBar.items?[0].title = "menu".localized

    }
}




