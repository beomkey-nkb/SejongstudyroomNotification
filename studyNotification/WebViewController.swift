//
//  WebViewController.swift
//  studyNotification
//
//  Created by 남기범 on 13/01/2019.
//  Copyright © 2019 남기범. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var studyWeb: UIWebView!
    
    var webURL = ""
    
    override var preferredStatusBarStyle:UIStatusBarStyle {
        return UIStatusBarStyle.lightContent //상태표시줄 색상 흰색
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadWebpage(webURL)
    }
    
    func loadWebpage(_ url: String){
        let myURL = URL(string: url)
        let myRequest  = URLRequest(url: myURL!)
        studyWeb.loadRequest(myRequest)
    }

    
    @IBAction func backButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
