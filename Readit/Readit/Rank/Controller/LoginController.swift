//
//  LoginController.swift
//  Readit
//
//  Created by kingcos on 10/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit
import AVOSCloud
import ProgressHUD

class LoginController: UIViewController {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    deinit {
        print("LoginController", #function)
    }
}

extension LoginController {
    func setupUI() {
        setupTextFields()
    }
    
    func setupTextFields() {
        XKeyBoard.registerHide(self)
        XKeyBoard.registerShow(self)
    }
}

extension LoginController {
    func keyboardWillHideNotification(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) { 
            self.topConstraint.constant = 10.0
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillShowNotification(_ notification: Notification) {
        self.topConstraint.constant = -200.0
        self.view.layoutIfNeeded()
    }
}

extension LoginController {
    @IBAction func loginButtonClick(_ sender: UIButton) {
        guard let userName = userNameTextField.text,
            let password = passwordTextField.text else { return }
        
        AVUser.logInWithUsername(inBackground: userName, password: password) { result, error in
            if error == nil {
                self.dismiss(animated: true)
            } else {
                var errorDesc = "登录失败，未知错误。"
                
                if let code = (error as NSError?)?.code {
                    switch code {
                    case 210:
                        errorDesc = "用户名或密码错误！"
                    case 211:
                        errorDesc = "用户名不存在！"
                    case 216:
                        errorDesc = "未验证邮箱！"
                    case 1:
                        errorDesc = "操作频繁，请稍后再试！"
                    default:
                        break
                    }
                }
                
                ProgressHUD.showError(errorDesc)
            }
        }
    }
}
