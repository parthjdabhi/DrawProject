//
//  DotView.swift
//  アウリクラリア
//
//  Created by 木耳ちゃん on 2016/05/21.
//  Copyright © 2016年 NeTGroup. All rights reserved.
//

import Foundation
import UIKit

class DotView:UIView{
    
    var width:CGFloat = 0
    var height:CGFloat = 0
    static var paddingHorizontal:CGFloat = 10
    static var paddingVertical:CGFloat = 10
    
    
    weak var targetImageView:PictureView?
    
    init(imageView:PictureView){
        super.init(frame:CGRectZero)
        self.backgroundColor = UIColor.clearColor()
        self.targetImageView = imageView
        self.frame = CGRectMake(imageView.frame.origin.x - Parts.marginHorizontal - DotView.paddingHorizontal,imageView.frame.origin.y - Parts.marginVertical - DotView.paddingVertical,imageView.frame.width + Parts.marginHorizontal * 2 + DotView.paddingHorizontal*2
            ,imageView.frame.height + Parts.marginVertical * 2 + DotView.paddingVertical*2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func drawRect(rect: CGRect) {
        let line = UIBezierPath()
        line.moveToPoint(CGPointMake(0,0))
        line.addLineToPoint(CGPointMake(self.frame.width,0));
        line.moveToPoint(CGPointMake(0,0))
        line.addLineToPoint(CGPointMake(0,self.frame.height));
        line.moveToPoint(CGPointMake(self.frame.width,0))
        line.addLineToPoint(CGPointMake(self.frame.width,self.frame.height));
        line.moveToPoint(CGPointMake(0,self.frame.height))
        line.addLineToPoint(CGPointMake(self.frame.width,self.frame.height));
        
        //点線パターン
        let dashPattern:[CGFloat] = [ 2 , 2 ]
        line.setLineDash(dashPattern, count:dashPattern.count, phase: 0)
        UIColor.blackColor().setStroke()
        line.lineWidth = 2
        line.stroke()
    }
    func pictureMove() {
        self.frame.origin.x = targetImageView!.frame.origin.x - DotView.paddingHorizontal - Parts.marginHorizontal
        self.frame.origin.y = targetImageView!.frame.origin.y - DotView.paddingHorizontal - Parts.marginVertical
    }
    //引数で受け付けた画像に合わせてリサイズします
    func sizeUpdate(image:PictureView)->Void{
        self.frame.size = CGSizeMake(image.frame.width + Parts.marginHorizontal * 2 + DotView.paddingHorizontal*2,image.frame.height + Parts.marginVertical * 2 + DotView.paddingVertical*2)
    }
    
    func repaint()->Void{
        self.setNeedsDisplay()
    }
    
}
