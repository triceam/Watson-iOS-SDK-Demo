//
//  ViewController.swift
//  Translator
//
//  Created by Andrew Trice on 12/17/15.
//  Copyright © 2015 Andrew Trice. All rights reserved.
//

import UIKit
import WatsonDeveloperCloud

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var input: UITextView?
    @IBOutlet weak var output: UITextView?
    @IBOutlet weak var targetLanguage: UIPickerView?
    
    let translation = LanguageTranslation(username:"your username", password: "your password")
    var models : [LanguageTranslation.TranslationModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.targetLanguage?.delegate = self;
        self.targetLanguage?.dataSource = self;
        
        
        translation.getModels("en") { models, error in
            
            self.models = models!
            
            print(models)
            dispatch_async(dispatch_get_main_queue(),{
                self.targetLanguage?.reloadAllComponents()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // MARK: - User Interaction
    
    @IBAction func doTranslation(sender: UIButton) {
        let inputText = self.input?.text
        let model = self.models[ (self.targetLanguage?.selectedRowInComponent(0))! ]
        
        translation.translate([inputText!], source: "en", target: model.target!) { text, error in
            let translation = text![0]
            
            //update the ui on the main thread
            dispatch_async(dispatch_get_main_queue(),{
                self.output!.text = translation
            })
        }
        self.input?.resignFirstResponder()
    }
    
    
    
    
    // MARK: - UIPickerViewDataSource & UIPickerViewDelegate
    
    internal func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    internal func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.models.count;
    }
    
    internal func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let model:LanguageTranslation.TranslationModel? = self.models[row]
        return model!.target! + " " + model!.domain!

    }


}

