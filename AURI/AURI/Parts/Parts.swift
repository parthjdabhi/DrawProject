//
//  Parts.swift
//  アウリクラリア
//
//  Created by 木耳ちゃん on 2016/05/18.
//  Copyright © 2016年 NeTGroup. All rights reserved.
//

import Foundation
import UIKit

class Parts:UIView{
    
    var partsTouchMove:PartsTouchMove?
    
    var dx:CGFloat = 0
    var dy:CGFloat = 0
    
    let width:CGFloat = 50
    let height:CGFloat = 50
    static var marginHorizontal:CGFloat = 0
    static var marginVertical:CGFloat = 0
    var isPressed:Bool = false
    var drugDimensionX:Bool = true
    var drugDimensionY:Bool = true
    weak var dotView:DotView?
    weak var targetImageView:PictureView?
    weak var superView:UIView?
    
   
    
    init(superView:UIView,targetImageView:PictureView,dotView:DotView){
        super.init(frame:CGRectZero)
        self.backgroundColor = UIColor.clearColor()
        self.superView = superView
        self.targetImageView = targetImageView
        self.dotView = dotView
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // タッチされた時の処理
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.isPressed = true
        self.setNeedsDisplay()
    }
    // タッチが動いた時の処理
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchEvent = touches.first!
        // ドラッグ前のX座標
        let preDx = touchEvent.previousLocationInView(self.superView).x
        let preDy = touchEvent.previousLocationInView(self.superView).y
        // ドラッグ後のX座標
        let newDx = touchEvent.locationInView(self.superView).x
        let newDy = touchEvent.locationInView(self.superView).y
        // ドラッグしたx座標の移動距離
        self.dx = preDx - newDx
        self.dy = preDy - newDy
        if dx > 0{
            drugDimensionX = true
        }else{
            drugDimensionX = false
        }
        if dy > 0{
            drugDimensionY = true
        }else{
            drugDimensionY = false
        }
        self.isPressed = true
    }
    // タッチが終わった時の処理
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //self.backgroundColor = UIColor.clearColor()
        self.isPressed = false
        self.setNeedsDisplay()
    }
}
protocol PartsTouchMove {
    func partsTouchMove(parts:Parts)
}



