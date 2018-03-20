//
//  ChatViewController.swift
//  RustRcon
//
//  Created by Louis Gornall on 26/11/2017.
//  Copyright © 2017 ShantyShackApps. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController , UITextFieldDelegate, UITextViewDelegate, chatView{

    var chatTail_includeServer: Bool = UserDefaults.standard.bool(forKey: "chatTail_includeServer")


//-----class variables-----\\
    var keyboardHeight: CGFloat = 0.0
    
    @IBOutlet weak var txtField_Chat: UITextField!
    
    @IBOutlet weak var chatOutput: UITextView!
    var receivedChatMessages: [NSMutableAttributedString] = []
    
    var textFieldisOffset: Bool = false
    
//-----IBACTIONS-----\\
    @IBAction func saybtnpressed(_ sender: UIButton) {
        let myNavBar = self.navigationController as! ServerNavViewController
        
        myNavBar.rconnection?.send(message: "say \(txtField_Chat.text!)", identifier: 500)
        txtField_Chat.text = ""
    }
    
    
//-----class loading------\\
    override func viewDidLoad() {
        super.viewDidLoad()
        txtField_Chat.delegate = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        self.chatOutput.layoutManager.allowsNonContiguousLayout = false
        // Do any additional setup after loading the view.
        
        let myNavBar = self.navigationController as! ServerNavViewController
        myNavBar.chatViewController = self
        
        myNavBar.rconnection?.requestChatTail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "chatTail_includeServer") != chatTail_includeServer {
            chatTail_includeServer = UserDefaults.standard.bool(forKey: "chatTail_includeServer")
            let myNavBar = self.navigationController as! ServerNavViewController
            myNavBar.chatViewController = self
            
            myNavBar.rconnection?.requestChatTail()
        }
        
    }
    
//-----Class Functions-----\\

    
    
    
    
//-----DELEGATE FUNCS-----\\
    func chatMessageReceived(chatMsgs: [NSMutableAttributedString]) {
        //chatOutput.text.append("\(chatMsgs.last!)\n\n")
        let currChat: NSMutableAttributedString = chatOutput.attributedText.mutableCopy() as! NSMutableAttributedString
        currChat.append(chatMsgs.last!)
        chatOutput.attributedText = currChat
        self.receivedChatMessages = chatMsgs
    }
    func chatTailReceived(chatTail: [NSMutableAttributedString]) {
        let newChat: NSMutableAttributedString = NSMutableAttributedString(string: "")
        for msg in chatTail{
            //chatOutput.text.append("\(msg)\n\n")
            //let currChat: NSMutableAttributedString = chatOutput.attributedText.mutableCopy() as! NSMutableAttributedString
            newChat.append(msg)

        }
        
        chatOutput.attributedText = newChat
        let stringLength:Int = self.chatOutput.text.count
        self.chatOutput.scrollRangeToVisible(NSMakeRange(stringLength-1, 0))
    }
    
    

//------KEYBOARD------\\
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height            
            
            if !textFieldisOffset && txtField_Chat.isEditing{
                textFieldisOffset = true
                moveTextField(textField: txtField_Chat, moveDistance: (Int(keyboardHeight) - Int(txtField_Chat.frame.origin.x) - Int((self.tabBarController?.tabBar.frame.height)!)), up: false)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Keyboard heihgt when ended, ",keyboardHeight)
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
