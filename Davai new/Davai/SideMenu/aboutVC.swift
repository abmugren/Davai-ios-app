//
//  aboutVC.swift
//  Davai
//
//  Created by Apple on 2/18/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer
import PKHUD

class aboutVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var viewVedio: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var arrayOfAbout :[About]?
    var moviePlayer:AVPlayerViewController!
    let APPLANGUAGE = Bundle.main.preferredLocalizations.first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getVideos()
        //setBtnMenu()
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 5
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        if UserDefaults.standard.string(forKey: "userType") == "user"{
            getAbout(type: "userAbout")
        }
        else if UserDefaults.standard.string(forKey: "userType") == "vendor"{
            getAbout(type: "clientAbout")
        }
        else {
            getAbout(type: "userAbout")
        }
        setupView()
        //playVideo(url: url!)
    }
    
    private func getAbout(type :String){
        if CheckInternet.Connection(){
            HUD.show(.progress)
            WebService.instance.getAbout(type: type) { (onSuccess, abouts) in
                if onSuccess{
                    self.arrayOfAbout = abouts
                    self.tableView.reloadData()
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
//    private func getVideos(){
//        if CheckInternet.Connection(){
//            HUD.show(.progress)
//            WebService.instance.getAboutVideo(type: "adsVideo") { (onSuccess, videos) in
//                if onSuccess{
//                    HUD.hide()
//                    self.playVideo(url: videos?[0].imgPath ?? "")
//                }
//                else{
//                    HUD.hide()
//                    HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened".localized))
//                }
//
//            }
//        }
//        else{
//            HUD.flash(.labeledError(title: "Error", subtitle: "Check your data connection!"))
//        }
//    }
//    private func playVideo(url:String){
//        let urll = URL(string: url)
//        moviePlayer = AVPlayerViewController(coder: urll)
//        moviePlayer.view.frame = viewVedio.frame
//        self.view.addSubview(moviePlayer.view)
//        moviePlayer.isFullscreen = true
//
//        moviePlayer.controlStyle = MPMovieControlStyle.embedded
//    }
    func playVideo(url: URL) {
//        let player = AVPlayer(url: url)
//        let vc = AVPlayerViewController()
//        vc.player = player
//
//        self.present(vc, animated: true) { vc.player?.play() }
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        player.play()
    }

    func setupView(){
        

        
        navigationItem.title = "AboutDavai".localized
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]

        tableView.layer.borderWidth = 2
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.cornerRadius = 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfAbout?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aboutCell", for: indexPath) as! aboutCell
        cell.aboutLabel.text = arrayOfAbout?[indexPath.row].titleEN
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
}
