//
//  settingController.swift
//  studyNotification
//
//  Created by 남기범 on 03/01/2019.
//  Copyright © 2019 남기범. All rights reserved.
//

import UIKit
import Firebase

class settingController: UIViewController {
    
    @IBOutlet weak var email: UILabel!
    
    override var preferredStatusBarStyle:UIStatusBarStyle {
        return UIStatusBarStyle.lightContent //상태표시줄 색상 흰색
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let usercurrent1 = Auth.auth().currentUser
        let tong:String = (usercurrent1?.email)!
        email?.text = "사용자 이메일 : " + tong
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
