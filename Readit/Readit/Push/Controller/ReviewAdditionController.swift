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
        view.backgroundColor = .white
        
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
        controller.delegate = self
        present(controller, animated: true)
    }
}

extension ReviewAdditionController: PhotoPickerControllerDelegate, VPImageCropperDelegate {
    func getFromPicker(_ image: UIImage) {
        let cropFrame = CGRect(x: 0.0, y: 100.0,
                               width: SCREEN_WIDTH, height: SCREEN_WIDTH * 1.273)
        let cropController = VPImageCropperViewController(image: image,
                                                      cropFrame: cropFrame,
                                                      limitScaleRatio: 3)
        
        cropController?.delegate = self
        
        guard let controller = cropController else { return }
        present(controller, animated: true)
    }
    
    func imageCropper(_ cropperViewController: VPImageCropperViewController!, didFinished editedImage: UIImage!) {
        headerView?.bookCover?.setImage(editedImage, for: .normal)
        
        cropperViewController.dismiss(animated: true)
    }
    
    func imageCropperDidCancel(_ cropperViewController: VPImageCropperViewController!) {
        cropperViewController.dismiss(animated: true)
    }
}

extension ReviewAdditionController {
    override func close() {
        dismiss(animated: true)
    }
    
    override func sure() {
        
    }
}
