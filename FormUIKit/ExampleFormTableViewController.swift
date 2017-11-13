//
//  ExampleFormTableViewController.swift
//  FormUIKit
//
//  Created by Sahand on 10/18/17.
//  Copyright © 2017 Sahand. All rights reserved.
//

import UIKit

class ExampleFormTableViewController: FormTableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var textField = FormTextDescription(tag: "typeSomething", title: "Label")
        textField.configureCell = {
            $0.textField.textAlignment = .right
            $0.textField.placeholder = "Field"
        }
        form.sections.append(FormSection(header: "Text fields", footer: "Text fields are simple cells with a UILabel and a UITextField.", fields: [.text(textField)]))
        
        var button = FormButtonDescription(tag: "sayHelloWorld", title: "Say \"Hello World\"")
        button.didTapButton = { _ in
            let alert = UIAlertController(title: "Hello world!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        form.sections.append(FormSection(header: "Buttons", footer: "Buttons are simple cells with a UIButton in them.", fields: [.button(button)]))
        
        var picker = FormPickerDescription(tag: "country", title: "Pick a country")
        picker.configureCell = {
            $0.textField.textAlignment = .right
            $0.textField.placeholder = "Choice"
        }
        picker.dataSourceForPicker = {
            return self
        }
        picker.valueForPickerSelection = { row, component in
            return "Hello \(row)"
        }
        form.sections.append(FormSection(header: "Pickers", footer: "Pickers are simple cells with a UILabel and a UITextField with a picker input.", fields: [.picker(picker)]))
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "hello world!!!! \(row)"
    }
}
