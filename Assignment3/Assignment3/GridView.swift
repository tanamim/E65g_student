//
//  GridView.swift
//  Assignment3
//
//  Created by Masakazu Tanami on 3/27/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

@IBDesignable class GridView: UIView {
    
    @IBInspectable var size: Int = 20 {
        didSet {
            grid = Grid(size, size)
        }
    }
    @IBInspectable var livingColor = UIColor(red:0.09, green:0.63, blue:0.52, alpha:1.0)  // Greensea
    @IBInspectable var bornColor   = UIColor(red:0.09, green:0.63, blue:0.52, alpha:0.6)
    @IBInspectable var emptyColor  = UIColor.darkGray
    @IBInspectable var diedColor   = UIColor.darkGray.withAlphaComponent(0.6)
    @IBInspectable var gridColor   = UIColor.black
    @IBInspectable var gridWidth   = CGFloat(2.0)
    
    var grid = Grid(20, 20)
    
    override func draw(_ rect: CGRect) {
        
        // draw multiple circles in rectangulars
        let size = CGSize(
            width: rect.size.width / CGFloat(self.size),
            height: rect.size.height / CGFloat(self.size)
        )
        let base = rect.origin
        (0 ..< self.size).forEach { i in
            (0 ..< self.size).forEach { j in
                let origin = CGPoint (
                    x: base.x + CGFloat(j) * size.width,
                    y: base.y + CGFloat(i) * size.height
                )
                let subRect = CGRect(
                    origin: origin,
                    size: size
                )
//                if grid[(i,j)].isAlive {
//                    let path = UIBezierPath(ovalIn: subRect)
//                    livingColor.setFill()
//                    path.fill()
//                }
                let path = UIBezierPath(ovalIn: subRect)
                switch grid[(i,j)] {
                case .alive: livingColor.setFill()
                case .born:  bornColor.setFill()
                case .died:  diedColor.setFill()
                case .empty: emptyColor.setFill()
                }
                path.fill()
            }
        }
        
        (0 ..< self.size + 1).forEach {
            // Vertical
            drawLine(start: CGPoint(x: CGFloat($0)/CGFloat(self.size) * rect.size.width, y:0.0),
                     end:   CGPoint(x: CGFloat($0)/CGFloat(self.size) * rect.size.width, y: rect.size.height))
            // Horizontal
            drawLine(start: CGPoint(x:0.0, y: CGFloat($0)/CGFloat(self.size) * rect.size.height),
                     end:   CGPoint(x:rect.size.width, y: CGFloat($0)/CGFloat(self.size) * rect.size.height))
        }
    }
    
    func drawLine(start:CGPoint, end: CGPoint) {
        let path = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        path.lineWidth = gridWidth
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        path.move(to: start)
        
        //add a point to the path at the end of the stroke
        path.addLine(to: end)
        
        //draw the stroke
        gridColor.setStroke()
        path.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = nil
    }
    
    // Updated since class
    typealias Position = (row: Int, col: Int)
    var lastTouchedPosition: Position?
    
    func process(touches: Set<UITouch>) -> Position? {
        guard touches.count == 1 else { return nil }
        let pos = convert(touch: touches.first!)
        guard lastTouchedPosition?.row != pos.row
            || lastTouchedPosition?.col != pos.col
            else { return pos }
        
//        grid[(pos)] = grid[(pos)].isAlive ? .empty : .alive
        grid[(pos)] = grid[(pos)].toggle(value: grid[(pos)])
        setNeedsDisplay()
        return pos
    }
    
    func convert(touch: UITouch) -> Position {
        let touchY = touch.location(in: self).y
        let gridHeight = frame.size.height
        let row = touchY / gridHeight * CGFloat(self.size)
        let touchX = touch.location(in: self).x
        let gridWidth = frame.size.width
        let col = touchX / gridWidth * CGFloat(self.size)
        let position = (row: Int(row), col: Int(col))
        return position
    }
}

