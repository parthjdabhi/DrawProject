//
//  BottomCenterParts.swift
//  アウリクラリア
//
//  Created by 木耳ちゃん on 2016/05/22.
//  Copyright © 2016年 NeTGroup. All rights reserved.
//

import Foundation
import UIKit

class BottomCenterParts:Parts{
    
    override init(superView:UIView,targetImageView:PictureView,dotView:DotView) {
        super.init(superView: superView, targetImageView: targetImageView, dotView: dotView)
        self.frame = CGRectMake(targetImageView.frame.origin.x + targetImageView.frame.width/2 - self.width/2,targetImageView.frame.origin.y+targetImageView.frame.height + Parts.marginVertical,self.width,self.height)

    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //枠線の描写
    override func drawRect(rect: CGRect) {
        let line = UIBezierPath(rect:CGRectMake(self.frame.width * 2/5,self.frame.height * 1/5 - self.frame.height/10,self.frame.width/5,self.frame.height/5))
        UIColor.blackColor().setStroke()
        line.lineWidth = 1
        
        if isPressed{
            UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.8).setFill()
            line.fill()
        }
        line.stroke()
    }

    // タッチが動いた時の処理
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches,withEvent: event)
        
        if !drugDimensionY{
            targetImageView?.frame = CGRectMake((targetImageView?.frame.origin.x)!, targetImageView!.frame.origin.y, (targetImageView?.frame.width)!, (targetImageView?.frame.height)! - dy)
            dotView?.frame = CGRectMake((dotView?.frame.origin.x)!, dotView!.frame.origin.y, (dotView?.frame.width)!, (dotView?.frame.height)! - dy)
        }else if targetImageView!.frame.height - dy >= PictureView.minHeight{
            targetImageView?.frame = CGRectMake((targetImageView?.frame.origin.x)!, targetImageView!.frame.origin.y, (targetImageView?.frame.width)!, (targetImageView?.frame.height)! - dy)
            dotView?.frame = CGRectMake((dotView?.frame.origin.x)!, dotView!.frame.origin.y, (dotView?.frame.width)!, (dotView?.frame.height)! - dy)
        }
        
        //自分もついていくようにします
        pictureMove()
        partsTouchMove?.partsTouchMove(self)
    }
    func pictureMove() {
        self.frame.origin.x = self.targetImageView!.frame.origin.x + self.targetImageView!.frame.width/2 - self.width/2
        self.frame.origin.y = self.targetImageView!.frame.origin.y+self.targetImageView!.frame.height + Parts.marginVertical
    }
}