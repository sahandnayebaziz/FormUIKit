//
//  ExampleFormTableViewController.swift
//  FormUIKit
//
//  Created by Sahand on 10/18/17.
//  Copyright © 2017 Sahand. All rights reserved.
//

import UIKit

class ExampleFormTableViewController: FormTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = FormButtonDescription(tag: "sayHelloWorld", title: "Say \"Hello World\"")
        form.sections.append(FormSection(header: "Buttons", footer: "Buttons are simple cells with a UIButton in them.", fields: [.button(button)]))
    }

}
