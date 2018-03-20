//
//  aboutViewController.swift
//  RustRcon
//
//  Created by Louis Gornall on 07/11/2017.
//  Copyright © 2017 ShantyShackApps. All rights reserved.
//

import UIKit
import MessageUI

class aboutViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "BackButton.png"), for: .normal) // Image can be downloaded from here below link
        backButton.tintColor = UIColor.white
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(backButton.tintColor, for: .normal) // You can change the TitleColor
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func emailBtnPressed(_ sender: Any) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(["theshantyshackgaming@gmail.com"])
        composeVC.setSubject("App Support")
        composeVC.setMessageBody("Enter your message", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    @IBAction func appStoreBtnPressed(_ sender: Any) {
        print("To the sppstore... hopefully")
        guard let url = URL(string : "itms-apps://itunes.apple.com/us/app/rust-rcon/id1296943474?mt=8") else {
            return
        }
            print(UIApplication.shared.canOpenURL(url))
            UIApplication.shared.open(url, options: [:], completionHandler: {success in print("success")})
            return
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}
