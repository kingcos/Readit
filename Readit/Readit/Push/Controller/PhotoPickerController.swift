//
//  PhotoPickerController.swift
//  Readit
//
//  Created by kingcos on 08/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit

class PhotoPickerController: UIViewController {

    var alert: UIAlertController?
    var imagePicker: UIImagePickerController?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if alert == nil {
            alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert?.addAction(UIAlertAction(title: "从相册选择", style: .default, handler: { action in
                self.selectPhotoInLibrary()
            }))
            
            alert?.addAction(UIAlertAction(title: "打开相机", style: .default, handler: { action in
                self.takePhoto()
            }))
            
            alert?.addAction(UIAlertAction(title: "取消", style: .cancel))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension PhotoPickerController {
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overFullScreen
        view.backgroundColor = .clear
        
        imagePicker = UIImagePickerController()
        imagePicker?.allowsEditing = false
        imagePicker?.delegate = self
        
    }
}

extension PhotoPickerController {
    
    func takePhoto() {
        
    }
    
    func selectPhotoInLibrary() {
        
    }
}

extension PhotoPickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}

