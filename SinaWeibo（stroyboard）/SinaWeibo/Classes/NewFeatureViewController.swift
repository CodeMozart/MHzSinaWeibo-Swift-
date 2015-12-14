//
//  NewFeatureViewController.swift
//  SinaWeibo
//
//  Created by Minghe on 11/12/15.
//  Copyright © 2015 Stanford swift. All rights reserved.
//

import UIKit
import SnapKit

class NewFeatureViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    ///
    let maxImageCount = 4
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - UICollectionView DataSource ------------------------------
    ///
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxImageCount
    }
    
    // 告诉系统当前行现实什么内容
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NewFeatureCell", forIndexPath: indexPath) as! MHzCollectionViewCell
        cell.index = indexPath.item
        
        // 以下代码，主要为了避免重用问题
        cell.startButton.hidden = true
        
        return cell
    }
    
    // MARK: - UICollectionView Delegate ------------------------------
    /**
    Tells the delegate that the specified cell was removed from the collection view.
    当一个cell显示完了之后（离开屏幕）会调用
    
    - parameter collectionView: 当前的collectionView
    - parameter cell:           上一页的那个cell
    - parameter indexPath:      上一页的索引
    */
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {

        // 1.获取当前展现在眼前的cell对应的索引
        let path = collectionView.indexPathsForVisibleItems().last!
        // 2.根据索引取出当前展现在眼前的cell
        let cell = collectionView.cellForItemAtIndexPath(path) as! MHzCollectionViewCell
        // 3.判断是不是最后一页
        if path.item == maxImageCount - 1
        {
            cell.startButton.hidden = false
            
            // 实现按钮出现的动画:
            // 1.动画时禁用按钮交互
            cell.startButton.userInteractionEnabled = false
            
            // 2.动画的具体代码
            // usingSpringWithDamping 的范围为 0.0f 到 1.0f ，数值越小「弹簧」的振动效果越明显。
            // initialSpringVelocity 则表示初始的速度，数值越大一开始移动越快, 值得注意的是，初始速度取值较高而时间较短时，也会出现反弹情况
            cell.startButton.transform = CGAffineTransformMakeScale(0.0, 0.0)
            
            UIView.animateWithDuration(2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 7.0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                
                cell.startButton.transform = CGAffineTransformIdentity
                
                }, completion: { (_) -> Void in
                    cell.startButton.userInteractionEnabled = true
            })
        }
    }
    
}



class MHzCollectionViewCell: UICollectionViewCell {
    
    // MARK: - 懒加载 ------------------------------
    /// 大图容器
    private lazy var iconView = UIImageView()
    /// 开始按钮
    private lazy var startButton: UIButton = {
        
        let btn = UIButton(backgroundImage: "new_feature_button")
        btn.addTarget(self, action: Selector("startBtnClick"), forControlEvents: .TouchUpInside)
        btn.sizeToFit()
        return btn
        
    }()
    
    ///
    var index: Int = 0
        {
        didSet{
            iconView.image = UIImage(named: "new_feature_\(index + 1)")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }

    
    // MARK: - 内部控制方法 ------------------------------
    ///
    private func setupUI() {
        //
        contentView.addSubview(iconView)
        contentView.addSubview(startButton)
        
        /*
        iconView.translatesAutoresizingMaskIntoConstraints = false
        var cons = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[iconView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["iconView": iconView])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[iconView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["iconView": iconView])
        contentView.addConstraints(cons)
        */
        
        iconView.snp_makeConstraints { (make) -> Void in
            
            make.edges.equalTo(0)
        }
        
        startButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView.snp_bottom).offset(-150)
        }
    }
    
    /// 点击开始按钮
    @objc private func startBtnClick() {
        // 发送通知，通知AppDelegate切换控制器
        NSNotificationCenter.defaultCenter().postNotificationName(MHzRootViewControllerChanged, object: self, userInfo: nil)
    }
    
    
}

//  注意：Swift文件中一个文件中可以定义多个类
class MHzFlowLayout: UICollectionViewFlowLayout {
    // 流水布局
    override func prepareLayout() {
        super.prepareLayout()
        
        itemSize = collectionView!.bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.pagingEnabled = true
    }
}





















