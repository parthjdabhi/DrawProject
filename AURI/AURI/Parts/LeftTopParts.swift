//
//  LeftTopParts.swift
//  アウリクラリア
//
//  Created by 木耳ちゃん on 2016/05/22.
//  Copyright © 2016年 NeTGroup. All rights reserved.
//


import Foundation
import UIKit

class LeftTopParts:Parts{
    
    override init(superView:UIView,targetImageView:PictureView,dotView:DotView) {
        super.init(superView: superView, targetImageView: targetImageView, dotView: dotView)
        self.frame = CGRectMake(targetImageView.frame.origin.x - Parts.marginHorizontal - self.width,targetImageView.frame.origin.y - Parts.marginVertical - self.height,self.width,self.height)

    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //枠線の描写
    override func drawRect(rect: CGRect) {
        let line = UIBezierPath(rect:CGRectMake(self.frame.width * 3/5 + self.frame.width/10,self.frame.height * 3/5 + self.frame.height/10,self.frame.width/5,self.frame.height/5))
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
        //ターゲットのImageViewを移動させます
        //Leftの移動
        if drugDimensionX{
            targetImageView?.frame = CGRectMake((targetImageView?.frame.origin.x)!-dx, (targetImageView?.frame.origin.y)!, (targetImageView?.frame.width)! + dx, (targetImageView?.frame.height)!)
            dotView?.frame = CGRectMake((dotView?.frame.origin.x)!-dx, (dotView?.frame.origin.y)!, (dotView?.frame.width)! + dx, (dotView?.frame.height)!)
        }else if targetImageView!.frame.width + dx >= PictureView.minWitdth{
            targetImageView?.frame = CGRectMake((targetImageView?.frame.origin.x)!-dx, (targetImageView?.frame.origin.y)!, (targetImageView?.frame.width)! + dx, (targetImageView?.frame.height)!)
            dotView?.frame = CGRectMake((dotView?.frame.origin.x)!-dx, (dotView?.frame.origin.y)!, (dotView?.frame.width)! + dx, (dotView?.frame.height)!)
        }
        //Topの移動
        if drugDimensionY{
            targetImageView?.frame = CGRectMake((targetImageView?.frame.origin.x)!, (targetImageView?.frame.origin.y)!-dy, (targetImageView?.frame.width)!, (targetImageView?.frame.height)! + dy)
            dotView?.frame = CGRectMake((dotView?.frame.origin.x)!, (dotView?.frame.origin.y)!-dy, (dotView?.frame.width)!, (dotView?.frame.height)! + dy)
        }else if targetImageView!.frame.height + dy >= PictureView.minHeight{
            targetImageView?.frame = CGRectMake((targetImageView?.frame.origin.x)!, (targetImageView?.frame.origin.y)!-dy, (targetImageView?.frame.width)!, (targetImageView?.frame.height)! + dy)
            dotView?.frame = CGRectMake((dotView?.frame.origin.x)!, (dotView?.frame.origin.y)!-dy, (dotView?.frame.width)!, (dotView?.frame.height)! + dy)
        }
        //自分もついていくようにします
        pictureMove()
        
        partsTouchMove?.partsTouchMove(self)
    }
    func pictureMove() {
        self.frame.origin.x = targetImageView!.frame.origin.x - Parts.marginHorizontal - self.width
        self.frame.origin.y = targetImageView!.frame.origin.y - Parts.marginVertical - self.height    }
}
