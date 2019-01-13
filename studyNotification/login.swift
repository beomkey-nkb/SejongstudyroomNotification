//
//  Login.swift
//  studyNotification
//
//  Created by 남기범 on 01/01/2019.
//  Copyright © 2019 남기범. All rights reserved.
//

import UIKit
import Kanna
import Alamofire
import SwiftSoup
import UserNotifications
import SwiftyJSON
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class login: UIViewController,GIDSignInUIDelegate{
    
    var handle: AuthStateDidChangeListenerHandle?
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override var preferredStatusBarStyle:UIStatusBarStyle {
        return UIStatusBarStyle.lightContent //상태표시줄 색상 흰색
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        self.view.endEditing(true)
        //키보드를 사라지게 해줌
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // [START auth_listener]
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // [START_EXCLUDE]
            print(user)
            // [END_EXCLUDE]
        }
        // [END auth_listener]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // [START remove_auth_listener]
        Auth.auth().removeStateDidChangeListener(handle!)
        // [END remove_auth_listener]
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                self.performSegue(withIdentifier: "loginMainView", sender: self)
            } else {
                // No user is signed in.
            }
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            
            if user != nil{
                
                print("login success")
                
            }
                
            else{
                let alertController = UIAlertController(title: "이메일이나 비밀번호가 틀렸습니다.",message: "다시 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
                
                //UIAlertActionStye.destructive 지정 글꼴 색상 변경
                let cancelButton = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
                
                alertController.addAction(cancelButton)
                
                self.present(alertController,animated: true,completion: nil)
                
                
                print("login failed")
                return
            }
            
        }
    }
}
