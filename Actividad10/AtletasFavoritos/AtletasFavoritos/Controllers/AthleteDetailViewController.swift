//
//  AthleteDetailViewController.swift
//  Clase 10
//
//  Created by Alumno on 15/4/26.
//

import UIKit

protocol AthleteDetailViewControllerDelegate : AnyObject {
    func athleteDetailViewController(_ controller: AthleteDetailViewController, didSave athlete: Athlete, at index: Int?)
}

class AthleteDetailViewController : UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var sportTextField: UITextField!
    
    weak var delegate: AthleteDetailViewControllerDelegate?
    
    var athlete: Athlete?
    var athleteIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = athlete == nil ? "Ingresar atleta" : "Editar atleta"
        
        if let athlete = athlete {
            nameTextField.text = athlete.name
            ageTextField.text = "\(athlete.age)"
            sportTextField.text = athlete.sport
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save, target: self, action: #selector(saveAthlete)
            //title: "Guardar", style: .prominent, target: self, action: #selector(saveAthlete)
        )
        
        let tagGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tagGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func saveAthlete() {
        guard let name = nameTextField.text, !name.isEmpty,
              let ageText = ageTextField.text, let age = Int(ageText),
              let sport = sportTextField.text, !sport.isEmpty else {
            showAlert()
            return
        }
        
        let athlete = Athlete(name: name, age: age, sport: sport)
        delegate?.athleteDetailViewController(self, didSave: athlete, at: athleteIndex)
        navigationController?.popViewController(animated: true)
    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: "Datos incompletos",
            message: "Completa todos los campos correctamente",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
