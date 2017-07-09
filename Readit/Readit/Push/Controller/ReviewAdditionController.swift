//
//  ReviewAdditionController.swift
//  Readit
//
//  Created by kingcos on 08/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit

let cellIdentifier = "Cell"

class ReviewAdditionController: UIViewController {

    var headerView: ReviewAdditionHeaderView?
    var tableView: UITableView?
    
    var tableViewTitles = [String]()
    var reviewTitle = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

extension ReviewAdditionController {
    func setupUI() {
        view.backgroundColor = .white
        
        setupHeader()
        setupTableView()
    }
    
    func setupHeader() {
        headerView = ReviewAdditionHeaderView(frame: CGRect(x: 0.0, y: 40.0,
                                                            width: SCREEN_WIDTH, height: 160.0))
        headerView?.delegate = self
        
        guard let headerView = headerView else { return }
        
        view.addSubview(headerView)
    }
    
    func setupTableView() {
        let frame = CGRect(x: 0.0, y: 200.0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 200.0)
        tableView = UITableView(frame: frame)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.tableFooterView = UIView()
        tableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        tableView?.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        
        guard let tableView = tableView else { return }
        view.addSubview(tableView)
        
        tableViewTitles = ["标题", "评分", "分类", "书评"]
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


extension ReviewAdditionController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        if indexPath.row != 1 {
            cell.accessoryType = .disclosureIndicator
        }
        
        switch indexPath.row {
        case 0:
            cell.detailTextLabel?.text = reviewTitle
        default:
            break
        }
        
        cell.textLabel?.text = tableViewTitles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            setReviewTitle()
        case 1:
            setReviewLevel()
        case 2:
            setReviewCategory()
        case 3:
            setReviewContent()
        default:
            break
        }
    }
}

extension ReviewAdditionController {
    func setReviewTitle() {
        let controller = PushTitleController()
        GeneralFactory.addTitle(in: controller)
        controller.callBack = { [weak self] title in
            guard let strongSelf = self,
                  let title = title else { return }
            strongSelf.reviewTitle = title
            strongSelf.tableView?.reloadData()
        }
        
        present(controller, animated: true)
    }
    
    func setReviewLevel() {
        let controller = PushLevelController()
        GeneralFactory.addTitle(in: controller)
        present(controller, animated: true)
    }
    
    func setReviewCategory() {
        let controller = PushCategoryController()
        GeneralFactory.addTitle(in: controller)
        present(controller, animated: true)
    }
    
    func setReviewContent() {
        let controller = PushContentController()
        GeneralFactory.addTitle(in: controller)
        present(controller, animated: true)
    }
}

extension ReviewAdditionController {
    override func sure() {
        
    }
}
