//
//  PushCategoryController.swift
//  Readit
//
//  Created by kingcos on 09/07/2017.
//  Copyright © 2017 kingcos. All rights reserved.
//

import UIKit

class PushCategoryController: UIViewController {

    var segmentLabel: UILabel?
    
    var segmentControl1: AKSegmentedControl?
    var segmentControl2: AKSegmentedControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

extension PushCategoryController {
    func setupUI() {
        view.backgroundColor = UIColor(231, 231, 231)

        setupSegmentLabel()
        setupSegmentControlls()
    }
    
    func setupSegmentLabel() {
        let frame = CGRect(x: (SCREEN_WIDTH - 300.0) / 2.0, y: 20.0, width: 300.0, height: 20.0)
        segmentLabel = UILabel(frame: frame)
        segmentLabel?.text = "请选择分类"
        segmentLabel?.shadowOffset = CGSize(width: 0.0, height: 1.0)
        segmentLabel?.shadowColor = .white
        segmentLabel?.textColor = UIColor(82, 113, 131)
        segmentLabel?.textAlignment = .center
        
        guard let segmentLabel = segmentLabel else { return }
        view.addSubview(segmentLabel)
    }
    
    func setupSegmentControlls() {
        let buttonsArray1 = [
            ["image": "ledger", "title": "文学"],
            ["image": "drama masks", "title": "人文社科"],
            ["image": "ledger", "title": "生活"]
        ]
        
        let buttonsArray2 = [
            ["image": "atom", "title": "经营"],
            ["image": "alien", "title": "科技"],
            ["image": "fire element", "title": "网络流行"]
        ]
        
        let frame1 = CGRect(x: 30.0, y: 60.0, width: SCREEN_WIDTH - 60.0, height: 37.0)
        segmentControl1 = AKSegmentedControl(frame: frame1)
        segmentControl1?.initButton(withTitleandImage: buttonsArray1)
        segmentControl1?.addTarget(self, action: #selector(segmentControlSelected(_:)), for: .touchUpOutside)
        
        let frame2 = CGRect(x: 30.0, y: 110.0, width: SCREEN_WIDTH - 60.0, height: 37.0)
        segmentControl2 = AKSegmentedControl(frame: frame2)
        segmentControl2?.initButton(withTitleandImage: buttonsArray2)
        segmentControl2?.addTarget(self, action: #selector(segmentControlSelected(_:)), for: .touchUpOutside)
        
        guard let segmentControl1 = segmentControl1 else { return }
        guard let segmentControl2 = segmentControl2 else { return }
        
        view.addSubview(segmentControl1)
        view.addSubview(segmentControl2)
    }
}

extension PushCategoryController {
    func segmentControlSelected(_ segment: AKSegmentedControl) {
        if segment == segmentControl1 {
            segmentControl2?.setSelectedIndex(3)
        } else {
            segmentControl1?.setSelectedIndex(3)
        }
    }
}

extension PushCategoryController {
    override func sure() {
        
    }
}
