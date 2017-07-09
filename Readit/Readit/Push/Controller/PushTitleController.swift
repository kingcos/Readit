//
//  PushTitleController.swift
//  Readit
//
//  Created by kingcos on 09/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit

typealias callBackPush = (_ content: String?) -> ()

class PushTitleController: UIViewController {

    var titleTextField: UITextField?
    var callBack: callBackPush?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

extension PushTitleController {
    func setupUI() {
        view.backgroundColor = .white
        
        setupTextField()
    }
    
    func setupTextField() {
        let frame = CGRect(x: 15.0, y: 60.0, width: SCREEN_WIDTH - 30.0, height: 30.0)
        titleTextField = UITextField(frame: frame)
        
        titleTextField?.borderStyle = .roundedRect
        titleTextField?.placeholder = "请输入书评标题"
        titleTextField?.becomeFirstResponder()
        
        guard let titleTextField = titleTextField else { return }
        view.addSubview(titleTextField)
    }
}

extension PushTitleController {
    override func sure() {
        guard let callBack = callBack else { return }
        callBack(titleTextField?.text)
        dismiss(animated: true)
    }
}
