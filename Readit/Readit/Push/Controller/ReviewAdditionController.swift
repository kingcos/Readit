//
//  ReviewAdditionController.swift
//  Readit
//
//  Created by kingcos on 08/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit

class ReviewAdditionController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

extension ReviewAdditionController {
    func setupUI() {
        view.backgroundColor = UIColor.white
    }
}

extension ReviewAdditionController {
    override func close() {
        dismiss(animated: true)
    }
    
    override func sure() {
        
    }
}
