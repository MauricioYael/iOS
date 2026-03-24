//
//  TaskViewController.swift
//  TaskFlow
//
//  Created by Alumno on 18/3/26.
//

import UIKit

struct Task {
    var title: String
    var isCompleted: Bool
}

class TaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var tasks: [Task] = [
        Task(title: "Comprar pan", isCompleted: false),
        Task(title: "Estudiar Swift", isCompleted: false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TaskFlow"
        tableView.dataSource = self
        tableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        let task = tasks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        content.secondaryText = task.isCompleted ? "Completada" : "Pendiente"
        cell.contentConfiguration = content
        cell.accessoryType = task.isCompleted ? .checkmark : .none
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetailSegue", sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue" {
            if let indexPath = sender as? IndexPath,
               let detailVC = segue.destination as? DetailViewController {
                detailVC.task = tasks[indexPath.row]
                detailVC.taskIndex = indexPath.row
                detailVC.onUpdateTask = { updatedTask, index in
                    self.tasks[index] = updatedTask
                    self.tableView.reloadData()
                }
                detailVC.onDeleteTask = { index in
                    self.tasks.remove(at: index)
                    self.tableView.reloadData()
                }
            }
        }
        
        if segue.identifier == "ShowAddTaskSegue" {
            if let nav = segue.destination as? UINavigationController,
                let addVC = nav.topViewController as? AddTaskViewController {
                addVC.onSaveTask = { newTitle in
                    let newTask = Task(title: newTitle, isCompleted: false)
                    self.tasks.append(newTask)
                    self.tableView.reloadData()
                }
            }
        }
    }
}
