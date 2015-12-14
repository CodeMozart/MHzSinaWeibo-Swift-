//
//  MHzTableViewCell.swift
//  SinaWeibo
//
//  Created by Minghe on 15/11/15.
//  Copyright © 2015年 Stanford swift. All rights reserved.
//

import UIKit
import SDWebImage

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
    
    
    /// 模型对象
    var status: Status?
        {
        didSet {
            /// 1.设置头像
//            let url = NSURL(string: status?.user?.profile_image_url ?? "")
            iconImageView.sd_setImageWithURL(status?.user?.avatarURL)
            /// 2.设置昵称
            nameLabel.text = status?.user?.screen_name ?? ""
            /// 3.设置时间
            timeLabel.text = status?.createdText ?? ""
            /// 4.设置来源
            sourceLabel.text = status?.sourceText ?? ""
            /// 5.设置正文
            contentLabel.text = status?.text ?? ""
            /// 6.认证图标
            verifiedImageView.image = status?.user?.verifiedImage
            /// 7.会员图片
            vipImageView.image = status?.user?.mbrankImage
        }
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
