//
//  PictureView.swift
//  AURI
//
//  Created by 木耳ちゃん on 2016/05/13.
//  Copyright © 2016年 NeTGroup. All rights reserved.
//

import Foundation
import UIKit

class PictureView:UIImageView{
    
    var movingX:CGFloat = 0
    var movingY:CGFloat = 0
    
    var trashAreaX = 0
    var trashAreaY = 0
    var trashAreaXx = 0
    var trashAreaYy = 0
    
    weak var superView:UIView?
    weak var trashButton:UIBarButtonItem?
    weak var trashArea:UIView?
    
    
    init() {
        super.init(frame: CGRectZero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(superView:UIView,trashButton:UIBarButtonItem,trashArea:UIView){
        self.init()
        self.superView = superView
        //自分をタッチ可能にします
        self.userInteractionEnabled = true
        self.trashButton = trashButton
        self.trashArea = trashArea
    }
    
    // タッチされた時の処理
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    
    
    // タッチが動いた時の処理
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchEvent = touches.first!
        // ドラッグ前の座標
        let preDx = touchEvent.previousLocationInView(self.superView).x
        let preDy = touchEvent.previousLocationInView(self.superView).y
        // ドラッグ後の座標
        let newDx = touchEvent.locationInView(self.superView).x
        let newDy = touchEvent.locationInView(self.superView).y
        self.movingX = newDx
        self.movingY = newDy
        // ドラッグしたx座標の移動距離
        let dx = newDx - preDx
        // ドラッグしたy座標の移動距離
        let dy = newDy - preDy
        // 画像のフレーム
        var viewFrame: CGRect = self.frame
        // 移動分を反映させる
        viewFrame.origin.x += dx
        viewFrame.origin.y += dy
        self.frame = viewFrame
        if pointIsContains(trashArea!){
            trashButton?.tintColor = UIColor.redColor()
        }else{
            trashButton?.tintColor = UIColor(red:0,green:122/255,blue:1,alpha:1)
        }
    }
    // タッチが終わった時の処理
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if pointIsContains(self.trashArea!){
            self.hidden = true
            trashButton?.tintColor = UIColor(red:0,green:122/255,blue:1,alpha:1)
        }
    }
    
    //タッチ点がViewに含まれているかの判定する関数です。
    func pointIsContains(view:UIView)->Bool{
        if view.frame.origin.x <= movingX && movingX <= view.frame.origin.x + view.frame.width{
            if self.movingY >= view.frame.origin.y && self.movingY <= view.frame.origin.y + view.frame.height{
                return true
            }
        }
        return false
    }
    
}
