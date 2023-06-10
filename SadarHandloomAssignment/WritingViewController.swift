//
//  ViewController.swift
//  SadarHandloomAssignment
//
//  Created by Sumayya Siddiqui on 09/06/23.
//

import UIKit
import MLKit

class WritingViewController: UIViewController {

    @IBOutlet weak var writingCanvasView: WritingCanvasView!
    private var recognizer: DigitalInkRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()

        let languageTag = "en-US"
        guard let identifier = DigitalInkRecognitionModelIdentifier(forLanguageTag: languageTag) else {
            // no model was found or the language tag couldn't be parsed, handle error.
            return
        }
        let model = DigitalInkRecognitionModel.init(modelIdentifier: identifier)
        let modelManager = ModelManager.modelManager()
        let conditions = ModelDownloadConditions.init(allowsCellularAccess: true, allowsBackgroundDownloading: true)
        modelManager.download(model, conditions: conditions)
        let options: DigitalInkRecognizerOptions = DigitalInkRecognizerOptions.init(model: model)
        recognizer = DigitalInkRecognizer.digitalInkRecognizer(options: options)
    }
}


