//
//  confirmationViewController.swift
//  RustRcon
//
//  Created by Louis Gornall on 22/11/2017.
//  Copyright © 2017 ShantyShackApps. All rights reserved.
//

import UIKit

class confirmationViewController: UIViewController {

    var notificationHeight: CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        print("Notification height will be ", notificationHeight)
        print("view height ",self.view.frame.height)
        notificationHeight =  self.view.frame.height
        notiButton.frame.size.height = 500.0
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var notiButton: UIButton!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
