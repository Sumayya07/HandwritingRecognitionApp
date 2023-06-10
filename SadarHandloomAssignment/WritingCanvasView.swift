//
//  WritingCanvasView.swift
//  SadarHandloomAssignment
//
//  Created by Sumayya Siddiqui on 10/06/23.
//

import UIKit
import MLKit

class WritingCanvasView: UIView {
    // Touch attributes
    private var lastPoint = CGPoint.zero
    private var strokes: [Stroke] = []
    private var points: [StrokePoint] = []
    private let kMillisecondsPerTimeInterval = 1000.0
    
    // Grid attributes
    private let gridSize: CGFloat = 20.0
    private let gridColor: UIColor = .lightGray
    
    // Drawing attributes
    private let strokeColor: UIColor = .black
    private let strokeLineWidth: CGFloat = 10.0
    private let strokePath = UIBezierPath()
    
    // MLKit
    var recognizer: DigitalInkRecognizer?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCanvas()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCanvas()
    }
    
    private func setupCanvas() {
        isMultipleTouchEnabled = false
        isUserInteractionEnabled = true
        backgroundColor = .white
    }
    
    override func draw(_ rect: CGRect) {
        drawGrid()
        
        strokeColor.set()
        strokePath.lineWidth = strokeLineWidth
        strokePath.stroke()
    }
    
    private func drawGrid() {
        let horizontalGridlines = Int(bounds.height / gridSize)
        let verticalGridlines = Int(bounds.width / gridSize)
        
        gridColor.set()
        
        for i in 0...horizontalGridlines {
            let y = CGFloat(i) * gridSize
            let startPoint = CGPoint(x: 0, y: y)
            let endPoint = CGPoint(x: bounds.width, y: y)
            UIBezierPath.drawLine(from: startPoint, to: endPoint, lineWidth: 0.5)
        }
        
        for i in 0...verticalGridlines {
            let x = CGFloat(i) * gridSize
            let startPoint = CGPoint(x: x, y: 0)
            let endPoint = CGPoint(x: x, y: bounds.height)
            UIBezierPath.drawLine(from: startPoint, to: endPoint, lineWidth: 0.5)
        }
    }
    
    private func addLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        strokePath.move(to: fromPoint)
        strokePath.addLine(to: toPoint)
        setNeedsDisplay()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        lastPoint = touch.location(in: self)
        let t = touch.timestamp
        points = [StrokePoint(x: Float(lastPoint.x), y: Float(lastPoint.y), t: Int(t * kMillisecondsPerTimeInterval))]
        addLine(from: lastPoint, to: lastPoint)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        let t = touch.timestamp
        points.append(StrokePoint(x: Float(currentPoint.x), y: Float(currentPoint.y), t: Int(t * kMillisecondsPerTimeInterval)))
        addLine(from: lastPoint, to: currentPoint)
        lastPoint = currentPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        let t = touch.timestamp
        points.append(StrokePoint(x: Float(currentPoint.x), y: Float(currentPoint.y), t: Int(t * kMillisecondsPerTimeInterval)))
        addLine(from: lastPoint, to: currentPoint)
        lastPoint = currentPoint
        
        strokes.append(Stroke(points: points))
        points = []
        
        doRecognition()
    }
    
    private func clearCanvas() {
        strokes.removeAll()
        setNeedsDisplay()
    }
    
    private func drawCandidateOnCanvas(_ candidate: String) {
        // Logic to draw the candidate on the canvas
        // Use the provided candidate string to render it on the canvas
    }
    
    func doRecognition() {
        let ink = Ink(strokes: strokes)
        recognizer?.recognize(ink: ink) { (result, error) in
            var title = ""
            var candidates: [String] = []
            
            if let result = result {
                if let candidate = result.candidates.first {
                    title = "Recognition Result"
                    candidates = [candidate.text]
                } else {
                    title = "Recognition Result"
                    candidates = ["No recognition candidates found."]
                }
            } else {
                title = "Recognition Error"
                candidates = [error?.localizedDescription ?? "Unknown error"]
            }
            
            DispatchQueue.main.async {
                let candidatesView = RecognitionCandidatesView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
                candidatesView.delegate = self
                candidatesView.displayRecognitionResult(title, candidates: candidates)
                
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                alert.view.addSubview(candidatesView)
                
                if let viewController = self.parentViewController() {
                    viewController.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

extension WritingCanvasView: RecognitionCandidatesViewDelegate {
    func recognitionCandidatesView(_ view: RecognitionCandidatesView, didSelectCandidate candidate: String) {
        clearCanvas()
        drawCandidateOnCanvas(candidate)
    }
}

extension UIResponder {
    func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension UIBezierPath {
    static func drawLine(from startPoint: CGPoint, to endPoint: CGPoint, lineWidth: CGFloat) {
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        path.stroke()
    }
}
