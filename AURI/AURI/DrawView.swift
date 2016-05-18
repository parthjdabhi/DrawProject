//
//  DrawView.swift
//  AURI
//
//  Created by 木耳ちゃん on 2016/05/07.
//  Copyright © 2016年 NeTGroup. All rights reserved.
//

import Foundation
import UIKit

class DrawableView: UIView {
    
    var path:UIBezierPath?
    var penColor:UIColor = UIColor.blackColor()
    var penSize:Int = 5
    var paths:[UIBezierPath] = []
    var colors:[UIColor] = []
    
    
    
    override func drawRect(rect: CGRect) {
        if !paths.isEmpty && !colors.isEmpty{
            for i in 0 ..< paths.count {
                colors[i].setStroke()
                paths[i].stroke()
            }
        }
        if let i = self.path{
            penColor.setStroke()
            i.stroke()
        }
    }
    
    // タッチされた時の処理
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let x = touches.first!.locationInView(self).x
        let y = touches.first!.locationInView(self).y
        //Pathを生成します
        self.path = UIBezierPath();
        //ペンサイズ設定です
        self.path!.lineWidth = CGFloat(self.penSize)
        self.path!.lineCapStyle = CGLineCap.Round
        self.path!.lineJoinStyle = CGLineJoin.Round
        self.path!.moveToPoint(CGPoint(x: x-1,y: y-1))
    }
    
    // タッチが動いた時の処理
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point = touches.first!.locationInView(self)
        self.path?.addLineToPoint(point)
        self.setNeedsDisplay()
    }
    
    // タッチが終わった時の処理
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point = touches.first!.locationInView(self)
        //現在の色をセット
        let color = self.penColor
        self.colors.append(color)
        self.path?.addLineToPoint(point)
        self.paths.append(self.path!)
        self.setNeedsDisplay()
    }
    //キャンバスを削除します
    func clear()->Void{
        paths.removeAll()
        if let i = self.path{
            i.removeAllPoints()
        }
        self.setNeedsDisplay()
    }
    
    func setColor(penColor:UIColor)->Void{
        self.penColor = penColor
    }
    
}