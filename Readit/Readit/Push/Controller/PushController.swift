//
//  PushController.swift
//  Readit
//
//  Created by kingcos on 08/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit

class PushController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

extension PushController {
    func setupUI() {
        view.backgroundColor = UIColor.white
        
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        let navigationView = UIView(frame: CGRect(x: 0.0, y: -20.0, width: SCREEN_WIDTH, height: 65))
        navigationView.backgroundColor = .white
        
        navigationController?.navigationBar.addSubview(navigationView)
        
        let addBookButton = UIButton(frame: CGRect(x: 20.0, y: 20.0, width: SCREEN_WIDTH, height: 45.0))
        addBookButton.setImage(#imageLiteral(resourceName: "plus circle"), for: .normal)
        addBookButton.setTitleColor(.black, for: .normal)
        addBookButton.setTitle("新建书评", for: .normal)
        addBookButton.contentHorizontalAlignment = .left
        addBookButton.addTarget(self, action: #selector(PushController.pushReviewAdditionController),
                                for: .touchUpInside)
        
        navigationView.addSubview(addBookButton)
    }
}

extension PushController {
    func pushReviewAdditionController() {
        let controller = ReviewAdditionController()
        
        GeneralFactory.addTitle("关闭", and: "发布", in: controller)
        
        present(controller, animated: true)
    }
}
