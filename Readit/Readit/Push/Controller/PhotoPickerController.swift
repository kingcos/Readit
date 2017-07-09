//
//  PhotoPickerController.swift
//  Readit
//
//  Created by kingcos on 08/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit

protocol PhotoPickerControllerDelegate {
    func getFromPicker(_ image: UIImage)
}

extension PhotoPickerControllerDelegate {
    func getFromPicker(_ image: UIImage) {
        fatalError("getImageFromPicker(:) has not been implemented")
    }
}

class PhotoPickerController: UIViewController {

    var alert: UIAlertController?
    
    var imagePicker: UIImagePickerController?
    
    var delegate: PhotoPickerControllerDelegate?
    
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
            
            alert?.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { action in
                self.dismiss(animated: false)
            }))
            
            guard let alert = alert else { return }
            present(alert, animated: true)
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
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker?.sourceType = .camera
            
            guard let imagePicker = imagePicker else { return }
            present(imagePicker, animated: true)
        } else {
            let alertController = UIAlertController(title: "无法获取相机", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "关闭", style: .cancel, handler: { action in
                self.dismiss(animated: false)
            }))
            present(alertController, animated: true)
        }
    }
    
    func selectPhotoInLibrary() {
        imagePicker?.sourceType = .photoLibrary
        
        guard let imagePicker = imagePicker else { return }
        present(imagePicker, animated: true)
    }
}

extension PhotoPickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker?.dismiss(animated: true) {
            self.dismiss(animated: false)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage]
        
        imagePicker?.dismiss(animated: true) {
            self.dismiss(animated: false) {
                guard let image = image as? UIImage else { return }
                self.delegate?.getFromPicker(image)
            }
        }
    }
}

