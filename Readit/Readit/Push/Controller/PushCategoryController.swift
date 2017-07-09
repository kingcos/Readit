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
    
    var literatureArray1: [[String: String]]?
    var literatureArray2: [[String: String]]?
    var humanityArray1: [[String: String]]?
    var humanityArray2: [[String: String]]? 
    var livelihoodArray1: [[String: String]]?
    var livelihoodArray2: [[String: String]]?
    var economyArray1: [[String: String]]?
    var economyArray2: [[String: String]]?
    var technologyArray1: [[String: String]]?
    var technologyArray2: [[String: String]]?
    var networkArray1: [[String: String]]?
    var networkArray2: [[String: String]]?
    
    var dropDownMenu1: IGLDropDownMenu?
    var dropDownMenu2: IGLDropDownMenu?
    
    var currentType = "文学"
    var detailType = "文学"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        setupUI()
    }
}

extension PushCategoryController {
    func setupUI() {
        view.backgroundColor = UIColor(231, 231, 231)

        setupSegmentLabel()
        setupSegmentControlls()
        
        guard let literatureArray1 = literatureArray1,
              let literatureArray2 = literatureArray2 else { return }
        setupDropMenusWith(literatureArray1, and: literatureArray2)
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
        segmentControl1?.addTarget(self, action: #selector(segmentControlSelected(_:)), for: .valueChanged)
        
        let frame2 = CGRect(x: 30.0, y: 110.0, width: SCREEN_WIDTH - 60.0, height: 37.0)
        segmentControl2 = AKSegmentedControl(frame: frame2)
        segmentControl2?.initButton(withTitleandImage: buttonsArray2)
        segmentControl2?.addTarget(self, action: #selector(segmentControlSelected(_:)), for: .valueChanged)
        
        guard let segmentControl1 = segmentControl1,
              let segmentControl2 = segmentControl2 else { return }
        
        view.addSubview(segmentControl1)
        view.addSubview(segmentControl2)
    }
    
    func setupDropMenusWith(_ array1: [[String: String]], and array2: [[String: String]]) {
        var dropDownItems1 = [IGLDropDownItem]()
        var dropDownItems2 = [IGLDropDownItem]()
        
        for dict in array1 {
            let item = IGLDropDownItem()
            item.text = dict["title"]
            dropDownItems1.append(item)
        }
        
        for dict in array2 {
            let item = IGLDropDownItem()
            item.text = dict["title"]
            dropDownItems2.append(item)
        }
        
        dropDownMenu1?.removeFromSuperview()
        dropDownMenu1 = IGLDropDownMenu()
        dropDownMenu1?.dropDownItems = dropDownItems1
        
        dropDownMenu2?.removeFromSuperview()
        dropDownMenu2 = IGLDropDownMenu()
        dropDownMenu2?.dropDownItems = dropDownItems2
        
        _ = [dropDownMenu1, dropDownMenu2].map {
            $0?.menuText = "点我展开详细列表"
            $0?.menuButton.textLabel.adjustsFontSizeToFitWidth = true
            $0?.menuButton.textLabel.textColor = UIColor(38, 82, 67)
            $0?.paddingLeft = 15.0
            $0?.delegate = self
            $0?.type = .stack
            $0?.itemAnimationDelay = 0.1
            $0?.gutterY = 5.0
        }
        
        dropDownMenu1?.frame = CGRect(x: 20.0, y: 150.0,
                                      width: SCREEN_WIDTH / 2.0 - 30.0, height: (SCREEN_HEIGHT - 200.0) / 7.0)
        dropDownMenu2?.frame = CGRect(x: SCREEN_WIDTH / 2.0 + 10.0, y: 150.0,
                                      width: SCREEN_WIDTH / 2.0 - 30.0, height: (SCREEN_HEIGHT - 200.0) / 7.0)
        
        guard let dropDownMenu1 = dropDownMenu1,
              let dropDownMenu2 = dropDownMenu2 else { return }

        view.addSubview(dropDownMenu1)
        view.addSubview(dropDownMenu2)
        
        dropDownMenu1.reloadView()
        dropDownMenu2.reloadView()
    }
}

extension PushCategoryController {
    func setupData(){
        literatureArray1 = [
            ["title": "小说"],
            ["title": "漫画"],
            ["title": "青春文学"],
            ["title": "随笔"],
            ["title": "现当代诗"],
            ["title": "戏剧"]
        ];
        literatureArray2 = [
            ["title": "传记"],
            ["title": "古诗词"],
            ["title": "外国诗歌"],
            ["title": "艺术"],
            ["title": "摄影"]
        ];
        
        humanityArray1 = [
            ["title": "历史"],
            ["title": "文化"],
            ["title": "古籍"],
            ["title": "心理学"],
            ["title": "哲学/宗教"],
            ["title": "政治/军事"],
        ];
        humanityArray2 = [
            ["title": "社会科学"],
            ["title": "法律"],
        ];
        
        livelihoodArray1 = [
            ["title": "休闲/爱好"],
            ["title": "孕产/胎教"],
            ["title": "烹饪/美食"],
            ["title": "时尚/美妆"],
            ["title": "旅游/地图"],
            ["title": "家庭/家居"],
        ];
        livelihoodArray2 = [
            ["title": "亲子/家教"],
            ["title": "两性关系"],
            ["title": "育儿/早教"],
            ["title": "保健/养生"],
            ["title": "体育/运动"],
            ["title": "手工/DIY"],
        ];
        
        economyArray1 = [
            ["title": "管理"],
            ["title": "投资"],
            ["title": "理财"],
            ["title": "经济"],
        ];
        economyArray2  = [
            ["title": "没有更多了"],
        ];
        
        technologyArray1 =  [
            ["title": "科普读物"],
            ["title": "建筑"],
            ["title": "医学"],
            ["title": "计算机/网络"],
        ];
        technologyArray2 = [
            ["title": "农业/林业"],
            ["title": "自然科学"],
            ["title": "工业技术"],
        ];
        
        networkArray1 = [
            ["title" :"玄幻/奇幻"],
            ["title" :"武侠/仙侠"],
            ["title" :"都市/职业"],
            ["title":"历史/军事"],
        ];
        networkArray2 =    [
            ["title": "游戏/竞技"],
            ["title": "科幻/灵异"],
            ["title": "言情"],
        ];
    }
}

extension PushCategoryController: IGLDropDownMenuDelegate {
    func dropDownMenu(_ dropDownMenu: IGLDropDownMenu!, selectedItemAt index: Int) {
        guard let item = dropDownMenu.dropDownItems[index] as? IGLDropDownItem else { return }
        detailType = item.text
        
        if dropDownMenu == dropDownMenu1 {
            dropDownMenu2?.menuButton.text = detailType
        } else {
            dropDownMenu1?.menuButton.text = detailType
        }
    }
}

extension PushCategoryController {
    func segmentControlSelected(_ segment: AKSegmentedControl) {
        var index = segment.selectedIndexes.rangeView.first?.lowerBound ?? 0
        
        guard let type = (segment.buttonsArray[index] as? UIButton)?.currentTitle else { return }
        currentType = type
        
        if segment == segmentControl1 {
            segmentControl2?.setSelectedIndex(3)
        } else {
            segmentControl1?.setSelectedIndex(3)
            
            index += 3
        }
        
        dropDownMenu1?.resetParams()
        dropDownMenu2?.resetParams()
        
        guard let literatureArray1 = literatureArray1,
            let literatureArray2 = literatureArray2,
            let humanityArray1 = humanityArray1,
            let humanityArray2 = humanityArray2,
            let livelihoodArray1 = livelihoodArray1,
            let livelihoodArray2 = livelihoodArray2,
            let economyArray1 = economyArray1,
            let economyArray2 = economyArray2,
            let technologyArray1 = technologyArray1,
            let technologyArray2 = technologyArray2,
            let networkArray1 = networkArray1,
            let networkArray2 = networkArray2 else { return }

        switch index {
        case 0:
            setupDropMenusWith(literatureArray1, and: literatureArray2)
        case 1:
            setupDropMenusWith(humanityArray1, and: humanityArray2)
        case 2:
            setupDropMenusWith(livelihoodArray1, and: livelihoodArray2)
        case 3:
            setupDropMenusWith(economyArray1, and: economyArray2)
        case 4:
            setupDropMenusWith(technologyArray1, and: technologyArray2)
        case 5:
            setupDropMenusWith(networkArray1, and: networkArray2)
        default:
            break
        }
    }
}

extension PushCategoryController {
    override func sure() {
        
    }
}
