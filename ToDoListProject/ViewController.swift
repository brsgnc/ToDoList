//
//  ViewController.swift
//  ToDoListProject
//
//  Created by Barış Genç on 13.12.2020.
//  Copyright © 2020 BG. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoList: Object {
    @objc dynamic var item: String = ""
    @objc dynamic var date: Date = Date()
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table: UITableView!
    
    private let realm = try! Realm()
    private var data = [ToDoList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        data = realm.objects(ToDoList.self).map({ $0 })
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .darkGray
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].item
        cell.backgroundColor = .systemRed
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = data[indexPath.row]
        guard let vc = storyboard?.instantiateViewController(identifier: "show") as? ShowEntryViewController else {
            return
        }
        vc.item = item
        vc.deletionHandler = {[weak self] in
            self?.refresh()
        }
        vc.title = item.item
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapAddButton() {
        guard let vc = storyboard?.instantiateViewController(identifier: "entry") as? AddEntryViewController else {
            return
        }
        vc.completionHandler = { [weak self] in
            self?.refresh()
        }
        vc.title = "Listeye Ekle"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func refresh() {
        data = realm.objects(ToDoList.self).map({ $0 })
        table.reloadData()
    }
}

