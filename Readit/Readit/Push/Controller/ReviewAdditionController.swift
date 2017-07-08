//
//  ReviewAdditionController.swift
//  Readit
//
//  Created by kingcos on 08/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit

class ReviewAdditionController: UIViewController {

    var headerView: ReviewAdditionHeaderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

extension ReviewAdditionController {
    func setupUI() {
        view.backgroundColor = UIColor.white
        
        setupHeader()
    }
    
    func setupHeader() {
        headerView = ReviewAdditionHeaderView(frame: CGRect(x: 0.0, y: 40.0,
                                                            width: SCREEN_WIDTH, height: 160.0))
        headerView?.delegate = self
        
        guard let headerView = headerView else { return }
        
        view.addSubview(headerView)
    }
}

extension ReviewAdditionController: ReviewAdditionHeaderViewDelegate {
    func selectCover() {
        let controller = PhotoPickerController()
        present(controller, animated: true)
    }
}

extension ReviewAdditionController {
    override func close() {
        dismiss(animated: true)
    }
    
    override func sure() {
        
    }
}
