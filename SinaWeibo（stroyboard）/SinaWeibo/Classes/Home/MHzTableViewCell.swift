//
//  MHzTableViewCell.swift
//  SinaWeibo
//
//  Created by Minghe on 15/11/15.
//  Copyright © 2015年 Stanford swift. All rights reserved.
//

import UIKit
import SDWebImage

// Swift中的枚举比OC强大很多, 可以赋值任意类型的数据, 以及可以定义方法
enum MHzTableViewCellIdentifier: String
{
    case NormalCellIdentifier = "originCell"
    case ForwardCellIdentifier = "forwardCell"
    
    static func identifierWithViewModel(viewModel: StatusViewModel) -> String
    {
        // rawValue代表获取枚举的原始值
        return (viewModel.status.retweeted_status != nil) ? ForwardCellIdentifier.rawValue : NormalCellIdentifier.rawValue
    }
}

class MHzTableViewCell: UITableViewCell {
    
    // MARK: - outlet ------------------------------
    /// 用户头像
    @IBOutlet weak var iconImageView: UIImageView!
    /// 会员图标
    @IBOutlet weak var vipImageView: UIImageView!
    /// 认证图标
    @IBOutlet weak var verifiedImageView: UIImageView!
    /// 昵称
    @IBOutlet weak var nameLabel: UILabel!
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    /// 正文
    @IBOutlet weak var contentLabel: UILabel!
    /// 正文的宽度约束
    @IBOutlet weak var contentLabelWidthCons: NSLayoutConstraint!
    /// 转发正文
    @IBOutlet weak var forwardContentLabel: UILabel!
    /// 转发正文的宽度约束
    @IBOutlet weak var forwardContentLabelWidthCons: NSLayoutConstraint!
    /// 配图容器
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    /// 配图容器宽度约束
    @IBOutlet weak var pictureCollectionViewWidthCons: NSLayoutConstraint!
    /// 配图容器高度约束
    @IBOutlet weak var pictureCollectionViewHeightCons: NSLayoutConstraint!
    /// 底部工具试图
    @IBOutlet weak var footerToolView: UIView!
    
    @IBOutlet weak var footerView: UIView!
    /// 模型对象
    var viewModel: StatusViewModel?
        {
        didSet {
            /// 1.设置头像
//            let url = NSURL(string: status?.user?.profile_image_url ?? "")
            iconImageView.sd_setImageWithURL(viewModel?.avatarURL)
            /// 2.设置昵称
            nameLabel.text = viewModel?.status.user?.screen_name ?? ""
//            nameLabel.text = viewModel?.status.retweeted_status.screen_name ?? ""
            /// 3.设置时间
            timeLabel.text = viewModel?.createdText ?? ""
            /// 4.设置来源
            sourceLabel.text = viewModel?.sourceText ?? ""
            /// 5.设置正文
            contentLabel.text = viewModel?.status.text ?? ""
            /// 6.认证图标
            verifiedImageView.image = viewModel?.verifiedImage
            /// 7.会员图片
            vipImageView.image = viewModel?.mbrankImage
            /// 8.配图
            let (itemSize, size) = calculateSize()
            pictureCollectionViewWidthCons.constant = size.width
            pictureCollectionViewHeightCons.constant = size.height
            if itemSize != CGSizeZero
            {
                (pictureCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = itemSize
                (pictureCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing = 5
                (pictureCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing = 5
            }
            /// 9.转发正文
            if let temp = viewModel?.status.retweeted_status?.text
            {
                forwardContentLabelWidthCons.constant = UIScreen.mainScreen().bounds.width - 20
                forwardContentLabel.text = temp
            }
            
            pictureCollectionView.reloadData()
            
        }
    }
    
    // MARK: - 外部控制方法 ------------------------------
    // 计算当前行高度
    func calculateRowHeight(viewModel: StatusViewModel) -> CGFloat
    {
        self.viewModel = viewModel
        
        layoutIfNeeded()
        
        return CGRectGetMaxY(footerView.frame)
    }
    
    
    // MARK: - 内部控制方法 ------------------------------
    /// 计算配图尺寸
    // 第一个参数：imageView的尺寸；第二个参数：配图容器的尺寸
    private func calculateSize() -> (CGSize, CGSize)
    {
        let count = viewModel?.thumbnail_pics?.count ?? 0
        
        if count == 0 {
            return (CGSizeZero,CGSizeZero)
        }
        
        if count == 1
        {
            let urlStr = viewModel!.thumbnail_pics!.last!.absoluteString

            // 加载已经下载好得图片
            if let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(urlStr) {
            // 获取图片的size

            return (image.size, image.size)

            }
        }
        
        var imageWidth : CGFloat = 90
        var imageHeight = imageWidth
        let imageMargin : CGFloat = 5
        
        if count == 4
        {
            let col : CGFloat = 2
            
            let width = col * imageWidth + (col - 1) * imageMargin
            let height = width
            
            return (CGSize(width: 90, height: 90), CGSize(width: width, height: height))
        }
        
        
        let col : CGFloat = 3
        let row = (count - 1) / 3 + 1
        
        let width = UIScreen.mainScreen().bounds.width - 20
        imageWidth = (width - (col - 1) * imageMargin) / col
        imageHeight = imageWidth
        let height = CGFloat(row) * imageHeight + CGFloat(row - 1) * imageMargin
        return (CGSize(width: imageWidth, height: imageHeight), CGSize(width: width, height: height))
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // 动态设置正文宽度约束
        contentLabelWidthCons.constant = UIScreen.mainScreen().bounds.width - 20
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension MHzTableViewCell: UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.thumbnail_pics?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pictureCell", forIndexPath: indexPath) as! MHzPictureCollectionViewCell
        
        let url = viewModel!.thumbnail_pics![indexPath.item]
        cell.imageURL = url
        
        return cell

    }
}

class MHzPictureCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageURL: NSURL?
        {
        didSet{
            imageView.sd_setImageWithURL(imageURL)
        }
    }
    
}
