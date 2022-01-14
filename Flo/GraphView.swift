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
class GraphView: UIView {
    
    private enum Constants {
        static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let margin: CGFloat = 20.0
        static let topBorder: CGFloat = 60
        static let bottomBorder: CGFloat = 50
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 5.0
        static let circleRadius: CGFloat = circleDiameter/2
        static let graphLineWidth = 2.0
    }
    
    @IBInspectable var startColor: UIColor = .red
    @IBInspectable var endColor: UIColor = .green
    
    var graphPoints = [4, 0, 6, 4, 5, 8, 3]
    
    private func graphPointForValue(at index: Int, _ rect: CGRect) -> CGPoint {
        return CGPoint(x: graphXPointForValue(at: index, rect),
                       y: graphYPointForValue(graphPoints[index], rect))
    }
    
    private func graphXPointForValue(at index: Int, _ rect: CGRect) -> CGFloat {
        let graphWidth = rect.width - Constants.margin * 2 - 4
        let spacing = graphWidth / CGFloat(self.graphPoints.count - 1)
        return CGFloat(index) * spacing + Constants.margin + 2
    }
    
    private func graphYPointForValue(_ value: Int, _ rect: CGRect) -> CGFloat {
        let graphHeight = rect.height - Constants.topBorder - Constants.bottomBorder
        let columnHeight = CGFloat(value) / CGFloat(maxValue()) * graphHeight
        return graphHeight + Constants.topBorder - columnHeight
    }
    
    private func maxValue() -> Int {
        graphPoints.max() ?? 0
    }
    
    override func draw(_ rect: CGRect) {
        drawBackground(rect)
        drawGraph(rect)
        drawHorizontalLines(rect)
    }
    
    private func drawBackground(_ rect: CGRect) {
        UIColor.white.setFill()
        UIBezierPath(rect: rect).fill()
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: Constants.cornerRadiusSize)
        path.addClip()
        
        guard let gradient = createBGGradient() else {
            return
        }
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        context.resetClip()
    }
    
    private func drawGraph(_ rect: CGRect) {
        let graphPath = UIBezierPath()
        graphPath.move(to: graphPointForValue(at: 0, rect))
        for i in 1..<graphPoints.count {
            graphPath.addLine(to: graphPointForValue(at: i, rect))
        }
        
        guard let clippingPath = graphPath.copy() as? UIBezierPath else {
            return
        }
        
        clippingPath.addLine(to: CGPoint(
            x: graphXPointForValue(at: graphPoints.count - 1, rect),
            y: rect.height))
        clippingPath.addLine(to: CGPoint(x: graphXPointForValue(at: 0, rect), y: rect.height))
        clippingPath.close()
        clippingPath.addClip()
        
        let graphStartPoint = CGPoint(x: Constants.margin, y: graphYPointForValue(maxValue(), rect))
        let graphEndPoint = CGPoint(x: Constants.margin, y: bounds.height)
        
        let context = UIGraphicsGetCurrentContext()
        if let gradient = createBGGradient() {
            context?.drawLinearGradient(gradient, start: graphStartPoint, end: graphEndPoint, options: [])
        }
        context?.resetClip()
        
        UIColor.white.setStroke()
        graphPath.lineWidth = Constants.graphLineWidth
        graphPath.stroke()
        for i in 0..<graphPoints.count {
            let point = graphPointForValue(at: i, rect)
            let circleRect = CGRect(x: point.x - Constants.circleRadius, y: point.y - Constants.circleRadius, width: Constants.circleDiameter, height: Constants.circleDiameter)
            UIBezierPath(ovalIn: circleRect).fill()
        }
    }
    
    private func createBGGradient() -> CGGradient? {
        let colors = [startColor.cgColor, endColor.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        return CGGradient(colorsSpace: colorSpace,colors: colors as CFArray, locations: colorLocations)
    }
    
    private func drawHorizontalLines(_ rect: CGRect) {
        let beginingOfGraphXPoint = graphXPointForValue(at: 0, rect)
        let endOfGraphXPoint = graphXPointForValue(at: graphPoints.count - 1, rect)
        let graphTopYPoint = graphYPointForValue(maxValue(), rect)
        let graphBottomYPoint = graphYPointForValue(0, rect)
        let graphMiddleYPoint = (graphTopYPoint + graphBottomYPoint)/2
        
        let linesPath = UIBezierPath()
        linesPath.move(to: CGPoint(x: beginingOfGraphXPoint, y: graphTopYPoint))
        linesPath.addLine(to: CGPoint(x: endOfGraphXPoint, y: graphTopYPoint))
        linesPath.move(to: CGPoint(x: beginingOfGraphXPoint, y: graphMiddleYPoint))
        linesPath.addLine(to: CGPoint(x: endOfGraphXPoint, y: graphMiddleYPoint))
        linesPath.move(to: CGPoint(x: beginingOfGraphXPoint, y: graphBottomYPoint))
        linesPath.addLine(to: CGPoint(x: endOfGraphXPoint, y: graphBottomYPoint))
        
        UIColor(white: 1.0, alpha: Constants.colorAlpha).setStroke()
        linesPath.lineWidth = 1.0
        linesPath.stroke()
    }
    
}
