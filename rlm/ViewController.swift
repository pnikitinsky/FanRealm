//
//  ViewController.swift
//  rlm
//
//  Created by pavel on 8/9/17.
//  Copyright © 2017 pavel. All rights reserved.
//

import UIKit
import RealmSwift
class ViewController: UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    UITextFieldDelegate {
    var people = [Person]()
    let realm = try! Realm()

    @IBOutlet var tableView: UITableView!
    @IBOutlet var search: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        search.delegate = self
        queryPeople()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = people[indexPath.row].name
        return cell
    }


    func addPeople() {
        let person = Person()
        person.name = "John"
        person.race = "Белый"
        person.age = 30
        try! realm.write {
            realm.add(person)
        }

    }

    func queryPeople() {
        let allPeople = realm.objects(Person.self)
        for human in allPeople {
            self.people.append(human)
        }
        self.tableView.reloadData()
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        self.people.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let text = textField.text?.characters, text.count > 0 {
                let predicate = NSPredicate(format: "name CONTAINS [j] %@", textField.text!)
                let fiteredPeople = self.realm.objects(Person.self).filter(predicate)
                for each in fiteredPeople {
                    self.people.append(each)
                }
                self.tableView.reloadData()
            } else {
                self.queryPeople()
            }
        }
        return true
    }
}

