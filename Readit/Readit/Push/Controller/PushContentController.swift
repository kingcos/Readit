//
//  PushContentController.swift
//  Readit
//
//  Created by kingcos on 09/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

typealias CallBackPushContent = (_ content: String?) -> ()

class PushContentController: UIViewController {

    var textView: JVFloatLabeledTextView?
    var callBack: CallBackPushContent?
    var content: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

extension PushContentController {
    func setupUI() {
        view.backgroundColor = .white
        
        setupTextView()
    }
    
    func setupTextView() {
        let frame = CGRect(x: 8.0, y: 58.0,
                           width: SCREEN_WIDTH - 16.0, height: SCREEN_HEIGHT - 58.0 - 8.0)
        textView = JVFloatLabeledTextView(frame: frame)
        textView?.placeholder = "您可以在这里撰写评价或者吐槽～"
        textView?.tintColor = .gray
        textView?.becomeFirstResponder()
        
        XKeyBoard.registerHide(self)
        XKeyBoard.registerShow(self)
        
        guard let textView = textView else { return }
        view.addSubview(textView)
    }
}


extension PushContentController {
    func keyboardWillHideNotification(_ notification: Notification) {
        textView?.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func keyboardWillShowNotification(_ notification: Notification) {
        let rect = XKeyBoard.returnWindow(notification)
        
        textView?.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: rect.height, right: 0.0)
    }
}

extension PushContentController {
    override func sure() {
        guard let callBack = callBack else { return }
        callBack(textView?.text)
        dismiss(animated: true)
    }
}
