//
//  ViewController.swift
//  SadarHandloomAssignment
//
//  Created by Sumayya Siddiqui on 09/06/23.
//

import UIKit
import MLKit
    
    
    class WritingViewController: UIViewController, WritingCanvasViewDelegate {

        @IBOutlet weak var writingCanvasView: WritingCanvasView!
        private var recognizer: DigitalInkRecognizer?

        override func viewDidLoad() {
            super.viewDidLoad()

            let languageTag = "en-US"
            guard let identifier = DigitalInkRecognitionModelIdentifier(forLanguageTag: languageTag) else {
                      print("Failed to create identifier for language tag \(languageTag)")
                      // no model was found or the language tag couldn't be parsed, handle error.
                      return
                  }
            let model = DigitalInkRecognitionModel.init(modelIdentifier: identifier)
            let modelManager = ModelManager.modelManager()
            let conditions = ModelDownloadConditions.init(allowsCellularAccess: true, allowsBackgroundDownloading: true)
            modelManager.download(model, conditions: conditions)
            let options: DigitalInkRecognizerOptions = DigitalInkRecognizerOptions.init(model: model)
            recognizer = DigitalInkRecognizer.digitalInkRecognizer(options: options)

            writingCanvasView.delegate = self
        }

        func didEndStroke(with strokes: [Stroke]) {
            doRecognition(with: strokes)
        }

        func doRecognition(with strokes: [Stroke]) {
            let ink = Ink(strokes: strokes)
            recognizer?.recognize(ink: ink) { (result, error) in
                if let error = error {
                    print("Error in recognition: \(error.localizedDescription)")
                    return
                }

                guard let result = result, let candidate = result.candidates.first else {
                    print("No recognition candidates found.")
                    return
                }

                self.displayRecognitionResult(candidate: candidate.text)
            }
        }

        func displayRecognitionResult(candidate: String) {
            // Display the recognition result. You can use an UILabel to show the result, for example:
            let resultLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 200, height: 20)) // Modify this to fit your needs
            resultLabel.text = "Recognition Result: \(candidate)"
            view.addSubview(resultLabel)
        }
        
        func didSelectRecognitionCandidate(_ candidate: String) {
            displayRecognitionResult(candidate: candidate) // Display the selected recognition candidate
        }

    }



