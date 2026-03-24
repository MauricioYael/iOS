//
//  DetailViewController.swift
//  TaskFlow
//
//  Created by Alumno on 18/3/26.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var completedSwitch: UISwitch!
    
    var task: Task?
    var taskIndex: Int?
    
    var onUpdateTask: ((Task, Int) -> Void)?
    var onDeleteTask: ((Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detalle"
        
        if let task = task {
            titleTextField.text = task.title
            completedSwitch.isOn = task.isCompleted
        }
    }

    @IBAction func saveChangesTapped(_ sender: UIButton) {
        guard let index = taskIndex else { return }
        
        guard let text = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else {
            showAlert(message: "El título no puede estar vacío.")
            return
        }
        
        let updatedTask = Task(title: text, isCompleted: completedSwitch.isOn)
        onUpdateTask?(updatedTask, index)
        navigationController?.popViewController(animated: true)
    }

    @IBAction func deleteTapped(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "Eliminar tarea",
            message: "¿Seguro que deseas eliminar esta tarea?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive, handler: { _ in
            if let index = self.taskIndex {
                self.onDeleteTask?(index)
                self.navigationController?.popViewController(animated: true)
            }
        }))
        
        present(alert, animated: true)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Atención", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
