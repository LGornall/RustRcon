//
//  ConsoleViewController.swift
//  RustRcon
//
//  Created by Louis Gornall on 25/09/2017.
//  Copyright © 2017 Louis Gornall. All rights reserved.
//

import UIKit

class ConsoleViewController: UIViewController, consoleView, UITextFieldDelegate, UITextViewDelegate {

    
    
    @IBOutlet weak var consoleOutput: UITextView!
    
    @IBOutlet weak var sendCommandButton: UIButton!
    @IBOutlet weak var keyboardConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var txtField_console: UITextField!
    
    var keyboardHeight: CGFloat = 0.0
    var textFieldisOffset: Bool = false
    
    @IBAction func sendbtnpressed(_ sender: UIButton) {
        let myNavBar = self.navigationController as! ServerNavViewController
        myNavBar.consoleViewdelegate = self
        myNavBar.rconnection?.send(message: txtField_console.text!, identifier: 500)
        
        txtField_console.text = ""
    }
    
    var receivedMessages: [String] = []
    var receivedChatMsg: [String] = []
    
    func loadNewMessages(newMessages : [String], currentMessages : [String]) {
        let difference = newMessages.count - currentMessages.count
        print(difference, " ",newMessages.count, " ",currentMessages.count)
            
        for message in newMessages[difference ..< newMessages.count]{
            consoleOutput.text.append("\(message)\n")
        }
    }
    
    /*func reloadMessages(){
        consoleOutput.text = ""
        var consoleSource: [String] = []

        consoleSource = receivedMessages

        if (consoleSource.isEmpty == false ){
            for message in consoleSource {
                consoleOutput.text.append("\(message)\n")
            }
        }
    }*/
    
    //----Keyboard funcs

    
    //keyboard hiding
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldisOffset = false
        moveTextField(textField: textField, moveDistance: (Int(keyboardHeight - (keyboardHeight * 2)) + Int((self.tabBarController?.tabBar.frame.height)!)), up: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func moveTextField(textField: UITextField, moveDistance: Int, up: Bool){
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        let myNavBar = self.navigationController as! ServerNavViewController
        //reloadMessages()
        
        myNavBar.consoleViewdelegate = self
        myNavBar.rconnection?.send(message: "status", identifier: 65)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        print("Notification about keyboard")
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            print(Int(txtField_console.frame.origin.x))
            
            if !textFieldisOffset && txtField_console.isEditing{
                textFieldisOffset = true
                moveTextField(textField: txtField_console, moveDistance: (Int(keyboardHeight) - Int(txtField_console.frame.origin.x) - Int((self.tabBarController?.tabBar.frame.height)!)), up: false)
            }
            
            //moveTextField(textField: txtField_console, moveDistance: (Int(keyboardHeight) - Int(txtField_console.frame.origin.x) - Int((self.tabBarController?.tabBar.frame.height)!)), up: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // serverNavbar funcs
    
    func messageReceived(messages: [String]) {
 
        consoleOutput.text.append("\(messages.last!)\n")
        self.receivedMessages = messages
    }
}
