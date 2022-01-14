/// Copyright (c) 2020 Razeware LLC
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

class ViewController: UIViewController {
    
    @IBOutlet private weak var counterView: CounterView!
    @IBOutlet private weak var counterLable: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var graphView: GraphView!
    @IBOutlet private weak var averageWaterDrunk: UILabel!
    @IBOutlet private weak var maxLabel: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var plusButton: PushButton!
    
    private var countOfGlasses = 0
    private var isGraphViewShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        counterView.counter = countOfGlasses
        counterLable.text = "\(countOfGlasses)"
        setupGraphDisplay()
    }
    
    private func buttonPressAnimation() -> CAAnimation {
        let symbolTransformation = CABasicAnimation(keyPath: "transform.scale")
        symbolTransformation.fromValue = 1
        symbolTransformation.toValue = 0.9
        symbolTransformation.duration = 0.5
        return symbolTransformation
    }
    
    func setupGraphDisplay() {
      let maxDayIndex = stackView.arrangedSubviews.count - 1
      graphView.graphPoints[graphView.graphPoints.count - 1] = counterView.counter
      graphView.setNeedsDisplay()
      maxLabel.text = "\(graphView.graphPoints.max() ?? 0)"
        
      let average = graphView.graphPoints.reduce(0, +) / graphView.graphPoints.count
      averageWaterDrunk.text = "Average: \(average)"
        
      let today = Date()
      let calendar = Calendar.current
      let formatter = DateFormatter()
      formatter.setLocalizedDateFormatFromTemplate("EEEEE")
      
      for i in 0...maxDayIndex {
        if let date = calendar.date(byAdding: .day, value: -i, to: today),
          let label = stackView.arrangedSubviews[maxDayIndex - i] as? UILabel {
          label.text = formatter.string(from: date)
        }
      }
    }
    
    @IBAction private func didTapPlus(_ sender: UIButton) {
        if countOfGlasses < 8 {
            countOfGlasses += 1
            updateUI()
        }
        if isGraphViewShowing {
            counterViewTap(nil)
        }
        
        sender.layer.add(buttonPressAnimation(), forKey: nil)
    }
    
    @IBAction private func didTapMinus(_ sender: UIButton) {
        if countOfGlasses > 0 {
            countOfGlasses -= 1
            updateUI()
        }
        if isGraphViewShowing {
            counterViewTap(nil)
        }
        
        sender.layer.add(buttonPressAnimation(), forKey: nil)
    }
    
    @IBAction func counterViewTap(_ gesture: UITapGestureRecognizer?) {
        // Hide Graph
        if isGraphViewShowing {
            UIView.transition(
                from: graphView,
                to: counterView,
                duration: 1.0,
                options: [.transitionFlipFromLeft, .showHideTransitionViews],
                completion: nil
            )
        } else {
            // Show Graph
            UIView.transition(
                from: counterView,
                to: graphView,
                duration: 1.0,
                options: [.transitionFlipFromRight, .showHideTransitionViews],
                completion: nil
            )
        }
        isGraphViewShowing.toggle()
    }
    
}
