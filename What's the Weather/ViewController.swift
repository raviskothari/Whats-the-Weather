//
//  ViewController.swift
//  What's the Weather
//
//  Created by Ravi Kothari on 1/3/18.
//  Copyright © 2018 Ravi Kothari. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var cityInputted: UITextField!
    @IBOutlet var resultOutput: UILabel!
    
    
    @IBAction func citySubmitted(_ sender: Any) {
        cityInputted.text = cityInputted.text?.capitalized
        print(cityInputted)
        if let myUrl = URL(string: "https://www.weather-forecast.com/locations/" + cityInputted.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
            let myRequest = NSMutableURLRequest(url: myUrl)
            let task = URLSession.shared.dataTask(with: myRequest as URLRequest) {
                data, response, error in
                var message = ""
                if error != nil {
                    print(error!)
                } else {
                    if let unwrappedData = data {
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        var stringSeperator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                        if let contentArray = dataString?.components(separatedBy: stringSeperator) {
                            if contentArray.count > 1 {
                                stringSeperator = "</span>"
                                let newContentArray = contentArray[1].components(separatedBy: stringSeperator)
                                if newContentArray.count > 1 {
                                    message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                    print(newContentArray[0])
                                }
                            }
                        }
                    }
                }
                if message == "" {
                    message = "The weather there couldn't be found. Please try again."
                }
                
                DispatchQueue.main.sync(execute: {
                    self.resultOutput.text = message
                })
            }
            task.resume()
        } else {
            resultOutput.text = "The weather there couldn't be found. Please try again."
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
