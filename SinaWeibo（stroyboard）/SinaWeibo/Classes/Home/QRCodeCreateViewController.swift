//
//  QRCodeCreateViewController.swift
//  SinaWeibo
//
//  Created by Minghe on 11/11/15.
//  Copyright © 2015 Stanford swift. All rights reserved.
//

import UIKit

class QRCodeCreateViewController: UIViewController {

    @IBOutlet weak var QRCodeCreateView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 1.创建滤镜对象
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        // 2.恢复默认设置
        filter?.setDefaults()
        
        // 3.设置二维码
        let data = "名赫不再是同学".dataUsingEncoding(NSUTF8StringEncoding)
        filter?.setValue(data, forKey: "inputMessage")
        
        // 4.从滤镜中取出二维码
        let ciImage = filter?.outputImage
        
        // 5.设置二维码到容器上
        QRCodeCreateView.image = createNonInterpolatedUIImageFormCIImage(ciImage!, size: 200)
    }
    
    
    /**
     生成高清二维码
     
     - parameter image: 需要生成原始图片
     - parameter size:  生成的二维码的宽高
     */
    private func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = CGRectIntegral(image.extent)
        let scale: CGFloat = min(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent))
        
        // 1.创建bitmap;
        let width = CGRectGetWidth(extent) * scale
        let height = CGRectGetHeight(extent) * scale
        let cs: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImageRef = context.createCGImage(image, fromRect: extent)
        
        CGContextSetInterpolationQuality(bitmapRef,  CGInterpolationQuality.None)
        CGContextScaleCTM(bitmapRef, scale, scale);
        CGContextDrawImage(bitmapRef, extent, bitmapImage);
        
        // 2.保存bitmap到图片
        let scaledImage: CGImageRef = CGBitmapContextCreateImage(bitmapRef)!
        
        return UIImage(CGImage: scaledImage)
    }

}
