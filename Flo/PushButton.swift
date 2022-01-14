/// Copyright (c) 2022 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

@IBDesignable
class PushButton: UIButton {
    
    private struct Constants {
        static let plusSize = 40.0
        static let plusLineWidth = 6.0
    }
    
    @IBInspectable var fillColor: UIColor = .green {
        didSet {
            pushButtonLayer?.fillColor = fillColor
        }
    }
    @IBInspectable var shape: String = PushButtonLayer.Shapes.plus {
        didSet {
            pushButtonLayer?.shape = shape
        }
    }
    
    var symbolLayer: CAShapeLayer!
    
    override class var layerClass: AnyClass {
        return PushButtonLayer.self
    }
    
    var pushButtonLayer: PushButtonLayer? {
        get {
            layer as? PushButtonLayer
        }
    }
    
    override func draw(_ rect: CGRect) {
    }
    
}

class PushButtonLayer: CALayer {
    
    private struct Constants {
        static let plusSize = 40.0
        static let plusLineWidth = 6.0
    }
    
    enum Shapes {
        static let plus = "plus"
        static let minus = "minus"
        static let oval = "oval"
    }
    
    override init(layer: Any) {
        if let pushButtonLayer = layer as? PushButtonLayer {
            self.shape = pushButtonLayer.shape
            self.fillColor = pushButtonLayer.fillColor
        }
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init() {
        super.init()
    }
    
    var fillColor: UIColor = .green
    @objc dynamic var shape: String = Shapes.plus
    
    override func animationKeys() -> [String]? {
        return ["shape"]
    }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == "shape" {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        drawBackground(in: ctx)
        drawSymbol(in: ctx)
    }
    
    private func drawBackground(in ctx: CGContext) {
        ctx.setFillColor(fillColor.cgColor)
        ctx.fillEllipse(in: bounds)
    }
    
    private func drawSymbol(in ctx: CGContext) {
        ctx.setStrokeColor(UIColor.white.cgColor)
        ctx.setLineWidth(Constants.plusLineWidth)

        if shape == Shapes.plus || shape == Shapes.minus {
            ctx.move(to: CGPoint(x: (bounds.width-Constants.plusSize)/2, y: bounds.height/2))
            ctx.addLine(to: CGPoint(x: (bounds.width+Constants.plusSize)/2, y: bounds.height/2))
        }

        if shape == Shapes.plus {
            ctx.move(to: CGPoint(x: bounds.width/2, y: (bounds.height-Constants.plusSize)/2))
            ctx.addLine(to: CGPoint(x: bounds.width/2, y: (bounds.height+Constants.plusSize)/2))
        }

        if shape == Shapes.oval {
            ctx.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: 10.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        }
        
        ctx.strokePath()
    }
    
}
