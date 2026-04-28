//
//  AthleteTableViewController.swift
//  Clase 10
//
//  Created by Alumno on 15/4/26.
//

import UIKit

class AthleteTableViewController: UIViewController {
 
    @IBOutlet weak var tableView : UITableView!
    
    var athletes: [Athlete] = [
        Athlete(name: "Cristiano Ronaldo", age: 90, sport: "Fútbol"),
        Athlete(name: "Lebron James", age: 39, sport: "Baloncesto"),
        Athlete(name: "Canelo Álvarez", age: 31, sport: "Boxeo")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Atletas"
        
        navigationItem.backButtonTitle = "Atrás"
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let destination = segue.destination as! AthleteDetailViewController
            destination.delegate = self
            
            if let indexPath = sender as? IndexPath {
                destination.athlete = athletes[indexPath.row]
                destination.athleteIndex = indexPath.row
            }
        }
    }
}

extension AthleteTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return athletes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let athlete = athletes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AthleteCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = athlete.name
        content.secondaryText = "\(athlete.sport) - \(athlete.age) años"
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath)
    }
}

extension AthleteTableViewController: AthleteDetailViewControllerDelegate {
    func athleteDetailViewController(_ controller: AthleteDetailViewController, didSave athlete: Athlete, at index: Int?) {
        if let index = index {
            athletes[index] = athlete
        } else {
            athletes.append(athlete)
        }
        
        tableView.reloadData()
    }
}
