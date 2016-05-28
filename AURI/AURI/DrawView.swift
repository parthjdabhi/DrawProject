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
class CanvasImage:NSObject,NSCoding{
    var frame:NSValue = NSValue(CGRect:CGRectZero)
    var image:UIImage
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.frame, forKey:"frame")
        aCoder.encodeObject(self.image, forKey:"image")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.frame = aDecoder.decodeObjectForKey("frame") as! NSValue
        self.image = aDecoder.decodeObjectForKey("image") as! UIImage
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
    var img:UIImage!

    
    
    override func drawRect(rect: CGRect) {
        if !imgs.isEmpty && !imgFrames.isEmpty{
            for i in 0 ..< imgs.count {
                imgs[i].drawInRect(imgFrames[i])
                print("画像が描画されました")
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
        colors.removeAll()
        if let i = self.path{
            i.removeAllPoints()
        }
        self.setNeedsDisplay()
    }
    //色をセットします
    func setColor(penColor:UIColor)->Void{
        self.penColor = penColor
    }
    //自分(DrawView)に描かれているUIBezierPathや色情報をNSData型で返します
    func getCanvasForNSData()->NSData{
        let canvas = self.canvas
        return NSKeyedArchiver.archivedDataWithRootObject(canvas)
    }
    //自分のpaths配列 または colors配列に追加します
    func addCanvas(data:NSData)->Void{
        let s = NSKeyedUnarchiver.unarchiveObjectWithData(data)
        self.paths.append((s?.path)!)
        self.colors.append((s?.color)!)
        self.setNeedsDisplay()
    }
    //自分の画像を追加
    func addImg(data:NSData)->Void{
        let s = NSKeyedUnarchiver.unarchiveObjectWithData(data)
        self.imgs.append(s as! UIImage)
        print("画像を貼り付け！")
        print("imgs.count->\(imgs.count)")
         print("imgFrames->\(imgFrames.count)")
        self.setNeedsDisplay()
    }
    //自分に張り付いているimgをNSData型で返します
    func getImageForNSData()->NSData{
        let img = self.img
        return NSKeyedArchiver.archivedDataWithRootObject(img)
    }
    //画像を仮引数で受け取り、プロパティimgs配列に追加します
    func addImage(image:UIImage,rect:CGRect)->Void{
        self.img = image
        self.imgFrames.append(rect)
        self.imgs.append(image)
        self.setNeedsDisplay()
    }
    func repaint()->Void{
        self.setNeedsDisplay()
    }
    
    
}
//画面から指を離した時に発行するデリゲート
protocol CanvasTouchUpDelegate {
    func canvasTouchUp()
}