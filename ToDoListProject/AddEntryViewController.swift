//
//  AddEntryViewController.swift
//  ToDoListProject
//
//  Created by Barış Genç on 13.12.2020.
//  Copyright © 2020 BG. All rights reserved.
//

import UIKit
import RealmSwift

class AddEntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var entryTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    private let realm = try! Realm()
    public var completionHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        entryTextField.becomeFirstResponder()
        entryTextField.delegate = self
        
        datePicker.setDate(Date(), animated: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Kaydet", style: .done, target: self, action: #selector(didTapSaveButton))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        entryTextField.resignFirstResponder()
        return true
    }

    @objc func didTapSaveButton() {
        if let text = entryTextField.text, !text.isEmpty {
            let date = datePicker.date
            let newItem = ToDoList()
            
            realm.beginWrite()
            newItem.date = date
            newItem.item = text
            realm.add(newItem)
            try! realm.commitWrite()
            
            completionHandler?()
            navigationController?.popToRootViewController(animated: true)
        }
        else {
            print("oops")
        }
    }
}
    


