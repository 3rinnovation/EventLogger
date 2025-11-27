//
//  ViewController.swift
//  EventLoggerExample
//
//  Created by 김지민 on 11/27/25.
//

import UIKit
import EventLogger

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func touchLogButtonAction(_ sender: Any) {
        guard let touchLogVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TouchLogViewController") as? TouchLogViewController else {
            return
        }
        
        if let data = FingerTouchEvent.loadFromFile(type: .direct),
           let logStr = String(data: data, encoding: .utf8) {
            touchLogVC.logText = logStr
        }

        present(touchLogVC, animated: true)
    }
}

class TouchLogViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var logText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = logText
    }
}
