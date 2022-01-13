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
class CounterView: UIView {
    
    private struct Constants {
        static let numberOfGlasses = 8
        static let lineWidth: CGFloat = 5.0
        static let arcWidthFraction = 0.6
        static let norchLenght = 8.0
        
        static var halfOfLineWidth: CGFloat {
            return lineWidth / 2
        }
    }
    
    @IBInspectable var counter: Int = 5 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var outlineColor: UIColor = UIColor.blue
    @IBInspectable var counterColor: UIColor = UIColor.orange
    
    override func draw(_ rect: CGRect) {
        let radius = min(rect.width/2, rect.height/2) - Constants.lineWidth
        let archWidth = radius*Constants.arcWidthFraction
        
        counterColor.setFill()
        outlineColor.setStroke()
        createArchPath(rect, radius, archWidth, Constants.numberOfGlasses).fill()
        let consumedGlassesPath = createArchPath(rect, radius - Constants.halfOfLineWidth, archWidth - Constants.lineWidth, counter)
        consumedGlassesPath.lineWidth = Constants.lineWidth
        consumedGlassesPath.stroke()
        norchesPath(rect, radius).stroke()

    }
    
    private func createArchPath(_ rect: CGRect, _ radius: CGFloat, _ arcWidth: CGFloat, _ numberOfGlasses: Int) -> UIBezierPath {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let startAgile = archAgile(for: 0)
        let endAgile = archAgile(for: numberOfGlasses)
        let externalArcRadius = radius
        let internalArcRadius = radius - arcWidth
        
        let path = UIBezierPath()
        path.addArc(withCenter: center, radius: externalArcRadius, startAngle: startAgile, endAngle: endAgile, clockwise: true)
        path.addArc(withCenter: center, radius: internalArcRadius, startAngle: endAgile, endAngle: startAgile, clockwise: false)
        path.close()
        return path
    }
    
    private func archAgile(for value: Int) -> CGFloat {
        let minValue = 135.0*CGFloat.pi/180.0
        let maxValue = 45.0*CGFloat.pi/180.0
        
        switch value {
        case 0: return minValue
        case 1: return 168.75*CGFloat.pi/180.0
        case 2: return 202.5*CGFloat.pi/180.0
        case 3: return 236.25*CGFloat.pi/180.0
        case 4: return 270.0*CGFloat.pi/180.0
        case 5: return 303.75*CGFloat.pi/180.0
        case 6: return 337.5*CGFloat.pi/180.0
        case 7: return 11.25*CGFloat.pi/180.0
        case 8: return maxValue
        default: return value < 0 ? minValue : maxValue
        }
    }
    
    private func norchesPath(_ rect: CGRect, _ radius: CGFloat) -> UIBezierPath {
        let norchesPath = UIBezierPath()
        norchesPath.lineWidth = Constants.lineWidth
        let archRadiusForStartPoint = radius
        let archRadiusForEndPoint = radius - Constants.norchLenght
        for i in 1...Constants.numberOfGlasses {
            norchesPath.move(to: pointOfNotch(for: i, rect, archRadiusForStartPoint))
            norchesPath.addLine(to: pointOfNotch(for: i, rect, archRadiusForEndPoint))
        }
        return norchesPath
    }
    
    private func pointOfNotch(for value: Int, _ rect: CGRect, _ archRadius: CGFloat) -> CGPoint {
        let archAgile = archAgile(for: value)
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let norchLocatedOnLeftFromCenter = archAgile > 90.0*CGFloat.pi/180.0 && archAgile < 270.0*CGFloat.pi/180.0
        let norchLocatedHigherThanCenter = archAgile > CGFloat.pi
        let nearestHorizontalAgile = (norchLocatedOnLeftFromCenter ? 180 : (norchLocatedHigherThanCenter ? 360 : 0))*CGFloat.pi/180.0
        let agileDifference = abs(nearestHorizontalAgile-archAgile)
        let xRelativeToCenter = archRadius*cos(agileDifference)
        let yRelaticeToCenter = archRadius*sin(agileDifference)
        return CGPoint(x: center.x + (norchLocatedOnLeftFromCenter ? -xRelativeToCenter : xRelativeToCenter),
                       y: center.y + (norchLocatedHigherThanCenter ? -yRelaticeToCenter : yRelaticeToCenter))
    }
    
}
