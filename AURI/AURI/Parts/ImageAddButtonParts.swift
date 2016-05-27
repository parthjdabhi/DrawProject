//
//  ImageAddButtonParts.swift
//  AURI
//
//  Created by 木耳ちゃん on 2016/05/26.
//  Copyright © 2016年 NeTGroup. All rights reserved.
//

import Foundation
import UIKit

class ImageAddButtonParts:UIView{
    
    var imageAddButtonTouch:ImageAddButtonTouch?
    
    var dx:CGFloat = 0
    var dy:CGFloat = 0
    
    let width:CGFloat = 50
    let height:CGFloat = 50
    static var marginHorizontal:CGFloat = 0
    static var marginVertical:CGFloat = 0
    var isPressed:Bool = false
    weak var targetImageView:PictureView?
    weak var superView:UIView?
    
    
    
    
    init(superView:UIView,targetImageView:PictureView) {
        super.init(frame: CGRectZero)
        self.targetImageView = targetImageView
        self.superView = superView
        self.frame = CGRectMake(targetImageView.frame.origin.x + targetImageView.frame.width + Parts.marginHorizontal + self.width,targetImageView.frame.origin.y + targetImageView.frame.height - Parts.marginVertical
            ,self.width,self.height)
        self.backgroundColor =  UIColor(red: 0, green: 255/255, blue: 200/255, alpha: 0.3)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //枠線の描写
    override func drawRect(rect: CGRect) {
//        let line = UIBezierPath(rect:CGRectMake(self.frame.width * 1/5 - self.frame.width/10,self.frame.height * 1/5 - self.frame.height/10,self.frame.width/5,self.frame.height/5))
//        UIColor.blackColor().setStroke()
//        line.lineWidth = 1
//        
//        if isPressed{
//            UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.8).setFill()
//            line.fill()
//        }
//        line.stroke()
    }
    //タッチした時の処理
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent:event)
        self.backgroundColor =  UIColor(red: 200, green: 0, blue: 0, alpha: 0.3)
        imageAddButtonTouch?.imageAddButtonTouch()
    }
    //タッチが終わった処理
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent:event)
        self.backgroundColor = UIColor(red: 0, green: 255/255, blue: 200/255, alpha: 0.3)
    }
    //画像がドラッグされている時の処理
    func pictureMove() {
        self.frame.origin.x = targetImageView!.frame.origin.x + targetImageView!.frame.width + Parts.marginHorizontal + self.width
        self.frame.origin.y = targetImageView!.frame.origin.y + targetImageView!.frame.height - Parts.marginVertical
    }
}
protocol ImageAddButtonTouch {
    func imageAddButtonTouch()
}

