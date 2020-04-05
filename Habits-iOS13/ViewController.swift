//
//  ViewController.swift
//  Habits-iOS13
//
//  Created by Dennis Nesanoff on 05.04.2020.
//  Copyright © 2020 Dennis Nesanoff. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate {
    
    var habits: [NSManagedObject] = []
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        title = "List"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Habit")
        do {
            habits = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
        }
    }
    
    @IBAction func addHabit(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New habit", message: "Add new habit", preferredStyle: .alert)
        let alertSave = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            if let text = alertController.textFields?.first?.text {
                self.save(title: text)
                self.tableView.reloadData()
            }
        }
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addTextField()
        alertController.addAction(alertSave)
        alertController.addAction(alertCancel)
        present(alertController, animated: true)
    }
    
    func save(title: String) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Habit", in: context)!
        let habit = NSManagedObject(entity: entity, insertInto: context)
        habit.setValue(title, forKey: "title")
        do {
            try context.save()
            habits.append(habit)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let habit = habits[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = habit.value(forKey: "title") as? String
        return cell
    }
}
