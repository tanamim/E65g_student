//
//  GridView.swift
//  Assignment3
//
//  Created by Masakazu Tanami on 3/27/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

@IBDesignable class GridView: UIView {
    // Assignment3 Part2
    @IBInspectable var size: Int = 20 {  // Default
        didSet {
            grid = Grid(size, size)      // Reinitialize when Inspectable size property chages
        }
    }
    
    // Assignment3 Part3: These values are also assigned in the storyboard as per the spec
    @IBInspectable var livingColor: UIColor = UIColor(red:0.09, green:0.63, blue:0.52, alpha:1.0)  // Greensea
    @IBInspectable var bornColor:   UIColor = UIColor(red:0.09, green:0.63, blue:0.52, alpha:0.6)
    @IBInspectable var emptyColor:  UIColor = UIColor.darkGray
    @IBInspectable var diedColor:   UIColor = UIColor.darkGray.withAlphaComponent(0.6)
    @IBInspectable var gridColor:   UIColor = UIColor.black
    @IBInspectable var gridWidth:   CGFloat = CGFloat(2.0)
    
    var grid = Grid(20, 20)
    
    override func draw(_ rect: CGRect) {
        // Assignment3 Part4
        // draw multiple circles in rectangulars
        let size = CGSize(
            width:  rect.size.width  / CGFloat(self.size),
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
                let path = UIBezierPath(ovalIn: subRect) // a new path for circle
                switch grid[(i,j)] {
                case .alive: livingColor.setFill()
                case .born:  bornColor.setFill()
                case .died:  diedColor.setFill()
                case .empty: emptyColor.setFill()
                }
                path.fill() // draw a circle
            }
        }
        
        // Assignment3 Part4
        (0 ..< self.size + 1).forEach {
            // Vertical
            drawLine(start: CGPoint(x: CGFloat($0)/CGFloat(self.size) * rect.size.width, y:0.0),
                     end:   CGPoint(x: CGFloat($0)/CGFloat(self.size) * rect.size.width, y: rect.size.height))
            // Horizontal
            drawLine(start: CGPoint(x:0.0, y: CGFloat($0)/CGFloat(self.size) * rect.size.height),
                     end:   CGPoint(x:rect.size.width, y: CGFloat($0)/CGFloat(self.size) * rect.size.height))
        }
    }
    
    /// Draw a grid line with gridWidth and gridColor
    ///
    /// - Parameters:
    ///   - start: initial point of a path stroke
    ///   - end:   end point of a path stroke
    func drawLine(start:CGPoint, end: CGPoint) {
        let path = UIBezierPath() // a new path for line
        path.move(to: start)
        path.addLine(to: end)
        path.lineWidth = gridWidth
        gridColor.setStroke()
        path.stroke()             // draw a grid line
    }

    // Assignment3 Part5
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
    
    /// Toggle touched circle between .empty and .alive
    ///
    /// - Parameter touches: Set<UITouch>
    /// - Returns: touched position
    func process(touches: Set<UITouch>) -> Position? {
        guard touches.count == 1 else { return nil }
        let pos = convert(touch: touches.first!)
        guard lastTouchedPosition?.row != pos.row
            || lastTouchedPosition?.col != pos.col
            else { return pos }
        grid[(pos.row, pos.col)] = grid[(pos.row, pos.col)].toggle(value: grid[(pos.row, pos.col)])  // toggle .empty <-> .alive
        setNeedsDisplay()
        return pos
    }
    
    /// Convert UITouch to Position
    ///
    /// - Parameter touch: UITouch
    /// - Returns: touched Position = (row: Int, col: Int)
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

