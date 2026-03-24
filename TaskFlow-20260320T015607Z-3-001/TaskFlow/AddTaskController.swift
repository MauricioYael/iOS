//
//  AddTaskController.swift
//  TaskFlow
//
//  Created by Alumno on 18/3/26.
//

import UIKit

class AddTaskViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    
    var onSaveTask: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Agregar"
    }

    @IBAction func saveTrapped(_ sender: UIButton) {
        print("Guardar")
        guard let text = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else {
            showAlert(message: "La tarea no puede estar vacia")
            return
        }
        
        print("texto \(text)")
        print("onSaveTask nil? \(onSaveTask == nil)")
        print("navigationController nil? \(navigationController == nil)")
        
        onSaveTask?(text)
        dismiss(animated: true)
    }
    
    @IBAction func cancelTrapped(_ sender: UIButton) {
        print("Cancelar")
        dismiss(animated: true)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Atencion", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
