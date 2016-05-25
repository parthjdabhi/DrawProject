//
//  DrawView.swift
//  AURI
//
//  Created by 木耳ちゃん on 2016/05/07.
//  Copyright © 2016年 NeTGroup. All rights reserved.
//

import Foundation
import UIKit

class Canvas:NSObject,NSCoding{
    var path:UIBezierPath?
    var color:UIColor?
    
    init(path:UIBezierPath,color:UIColor) {
        super.init()
        self.path = path
        self.color = color
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.path, forKey:"path")
        aCoder.encodeObject(self.color, forKey:"color")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.path = aDecoder.decodeObjectForKey("path") as? UIBezierPath
        self.color = aDecoder.decodeObjectForKey("color") as? UIColor
    }
    
}

class DrawableView: UIView {
    var canvasTouchUpDelegate: CanvasTouchUpDelegate?
    
    var path:UIBezierPath?
    var penColor:UIColor = UIColor.blackColor()
    var penSize:Int = 5
    var paths:[UIBezierPath] = []
    var colors:[UIColor] = []
    var canvas:Canvas?
    
    var lastTouchPoint:CGPoint = CGPointMake(0, 0)
    var posX :CGFloat = 0
    var posY :CGFloat = 0

    
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
        let currentPoint = touches.first!.locationInView(self)
        self.posX = lastTouchPoint.x
        self.posY = lastTouchPoint.y
        //Pathを生成します
        self.path = UIBezierPath();
        //ペンサイズ設定です
        self.path!.lineWidth = CGFloat(self.penSize)
        self.path!.lineCapStyle = CGLineCap.Round
        self.path!.lineJoinStyle = CGLineJoin.Round
        self.path!.moveToPoint(CGPoint(x: posX-1,y: posY-1))
        
        lastTouchPoint = currentPoint;
    }
    
    // タッチが動いた時の処理
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchEvent = touches.first!
        let currentPoint = touchEvent.locationInView(self)
        // ドラッグ前の座標
        let pre = touchEvent.previousLocationInView(self)
        let preDx = touchEvent.previousLocationInView(self).x
        let preDy = touchEvent.previousLocationInView(self).y
        // ドラッグ後の座標
        let new = touchEvent.locationInView(self)
        let newDx = touchEvent.locationInView(self).x
        let newDy = touchEvent.locationInView(self).y
        
        var lllPoint:CGPoint = CGPointMake(newDx - preDx,newDy-preDy)
        
        var midPoint:CGPoint = CGPointMake((lastTouchPoint.x + currentPoint.x) / 2,(lastTouchPoint.y + currentPoint.y) / 2)
   
        self.path?.addQuadCurveToPoint(midPoint, controlPoint:lastTouchPoint)
       
        lastTouchPoint = currentPoint
        
//        print("preDx\(preDx)")
//        print("newDx\(newDx)")
//        print("---")
        self.setNeedsDisplay()
    }
    
    // タッチが終わった時の処理
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let currentPoint = touches.first!.locationInView(self)
        //現在の色をセット
        let color = self.penColor
        self.colors.append(color)
        self.path?.addQuadCurveToPoint(currentPoint, controlPoint:lastTouchPoint)
        self.paths.append(self.path!)
        self.setNeedsDisplay()
        self.canvas = Canvas(path:self.path!, color:color)
        self.canvasTouchUpDelegate?.canvasTouchUp()
    }
    //キャンバスを削除します
    func clear()->Void{
        paths.removeAll()
        if let i = self.path{
            i.removeAllPoints()
        }
        self.setNeedsDisplay()
    }
    //色をセットします
    func setColor(penColor:UIColor)->Void{
        self.penColor = penColor
    }
    //自分(DrawView)に描かれているUIBezierPathや色情報をAnyObject型で返します
    func getCanvasForNSData()->NSData{
        let canvas = self.canvas
        return NSKeyedArchiver.archivedDataWithRootObject(canvas!)
    }
    //自分のpaths配列 または colors配列に追加します
    func addStatus(data:NSData)->Void{
        let s = NSKeyedUnarchiver.unarchiveObjectWithData(data)
        self.paths.append((s?.path)!)
        self.colors.append((s?.color)!)
        self.setNeedsDisplay()
    }
    
    
    
}
//画面から指を離した時に発行するデリゲート
protocol CanvasTouchUpDelegate {
    func canvasTouchUp()
}