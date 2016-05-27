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
    var path:UIBezierPath
    var color:UIColor
    var imgX:CGFloat = 0
    var imgY:CGFloat = 0
    
    init(path:UIBezierPath,color:UIColor) {
        self.path = path
        self.color = color
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.path, forKey:"path")
        aCoder.encodeObject(self.color, forKey:"color")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.path = aDecoder.decodeObjectForKey("path") as! UIBezierPath
        self.color = aDecoder.decodeObjectForKey("color") as! UIColor
    }
}

class DrawableView: UIView {
    var canvasTouchUpDelegate: CanvasTouchUpDelegate?
    
    var path:UIBezierPath!
    var penColor:UIColor = UIColor.blackColor()
    var penSize:Int = 5
    var paths:[UIBezierPath] = []
    var colors:[UIColor] = []
    var imgs:[UIImage] = []
    var imgFrames:[CGRect]=[]
    //通信用アイテム
    var canvas:Canvas!
    var pictureViewRect:CGRect = CGRectZero

    
    
    override func drawRect(rect: CGRect) {
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        
        if !imgs.isEmpty && !imgFrames.isEmpty{
            for i in 0 ..< imgs.count {
                //                CGContextTranslateCTM(context, 0,self.pictureViewRect.size.height);
                //                CGContextScaleCTM(context, 1, -1);
                CGContextDrawImage(context,imgFrames[i],imgs[i].CGImage)
            }
        }

        
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
        self.path.lineWidth = CGFloat(self.penSize)
        self.path.lineCapStyle = CGLineCap.Round
        self.path.lineJoinStyle = CGLineJoin.Round
        self.path.moveToPoint(CGPoint(x: x-1,y: y-1))
    }
    
    // タッチが動いた時の処理
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let currentPoint = touches.first!.locationInView(self)
        self.path.addLineToPoint(currentPoint)
        self.setNeedsDisplay()
    }
    
    // タッチが終わった時の処理
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let currentPoint = touches.first!.locationInView(self)
        //現在の色をセット
        self.path.addLineToPoint(currentPoint)
        self.colors.append(self.penColor)
        self.paths.append(self.path)
        self.setNeedsDisplay()
        self.canvas = Canvas(path:self.path, color:self.penColor)
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
//        self.imgs.append((s?.img)!)
        self.setNeedsDisplay()
    }
    //画像を仮引数で受け取り、プロパティimgs配列に追加します
    func addImage(image:UIImage,rect:CGRect)->Void{
        self.imgFrames.append(rect)
        self.imgs.append(image)
        self.setNeedsDisplay()
        print(self.imgs.count)
    }
    
    
    
}
//画面から指を離した時に発行するデリゲート
protocol CanvasTouchUpDelegate {
    func canvasTouchUp()
}