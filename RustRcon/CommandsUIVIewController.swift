//
//  CommandsUIVIewController.swift
//  RustRcon
//
//  Created by Louis Gornall on 03/10/2017.
//  Copyright © 2017 Louis Gornall. All rights reserved.
//

import UIKit

class CommandsUIVIewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var commandsTableView: UITableView!
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UITableViewCell
        
        return cell
        
    }
    

    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commandsTableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
