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
    var reviewScore: LDXScore?
    var isShowingScore = false
    
    var currentType = "文学"
    var detailType = "文学"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    deinit {
        print("ReviewAdditionController", #function)
    }
}

extension ReviewAdditionController {
    func setupUI() {
        view.backgroundColor = .white
        
        setupHeader()
        setupTableView()
    }
    
    func setupHeader() {
        headerView = ReviewAdditionHeaderView(frame: CGRect(x: 0.0, y: 45.0,
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
        
        reviewScore = LDXScore(frame: CGRect(x: SCREEN_WIDTH - 100.0, y: 10.0, width: 100.0, height: 22.0))
        reviewScore?.isSelect = true
        reviewScore?.normalImg = #imageLiteral(resourceName: "btn_star_evaluation_normal")
        reviewScore?.highlightImg = #imageLiteral(resourceName: "btn_star_evaluation_press")
        reviewScore?.max_star = 5
        reviewScore?.show_star = 5
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
        
        if indexPath.row != 1 && !isShowingScore {
            cell.accessoryType = .disclosureIndicator
        }
        
        switch indexPath.row {
        case 0:
            cell.detailTextLabel?.text = reviewTitle
        case 1:
            break
        case 2:
            if !isShowingScore {
                cell.detailTextLabel?.text = currentType + "->" + detailType
            }
        default:
            break
        }
        
        if isShowingScore && indexPath.row == 2 {
            if let reviewScore = reviewScore {
                cell.contentView.addSubview(reviewScore)
            }
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
            if !isShowingScore {
                setReviewCategory()
            } else {
                setReviewLevel()
            }
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
        isShowingScore = !isShowingScore
        
        if isShowingScore {
            tableView?.beginUpdates()
            
            let tempIndexPath = IndexPath(row: 2, section: 0)
            
            tableViewTitles.insert("", at: 2)
            tableView?.insertRows(at: [tempIndexPath], with: .left)
            
            tableView?.endUpdates()
        } else {
            tableView?.beginUpdates()
            
            guard let reviewScore = reviewScore else { return }
            tableView?.cellForRow(at: IndexPath(row: 1, section: 0))?.detailTextLabel?.text = "\(reviewScore.show_star)"
            
            let tempIndexPath = IndexPath(row: 2, section: 0)
            
            tableViewTitles.remove(at: 2)
            tableView?.deleteRows(at: [tempIndexPath], with: .right)
            
            tableView?.endUpdates()
        }
    }
    
    func setReviewCategory() {
        let controller = PushCategoryController()
        GeneralFactory.addTitle(in: controller)
        
        guard let button1 = controller.view.viewWithTag(1000) as? UIButton else { return }
        guard let button2 = controller.view.viewWithTag(1001) as? UIButton else { return }
        
        button1.setTitleColor(UIColor(38, 82, 67), for: .normal)
        button2.setTitleColor(UIColor(38, 82, 67), for: .normal)
        
        controller.currentType = currentType
        controller.detailType = detailType
        controller.callBack = { [weak self] currentType, detailType in
            guard let strongSelf = self,
                  let currentType = currentType,
                  let detailType = detailType else { return }
            
            strongSelf.currentType = currentType
            strongSelf.detailType = detailType
            
            strongSelf.tableView?.reloadData()
        }
        
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
