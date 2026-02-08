//
//  ViewController.swift
//  Curriculum_UIkit
//
//  Created by José Solís Romero on 07/02/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var messageButton: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View controller code")
        
        name.text = "Mauricio Yael"
    }
    
    @IBAction func modifyMessageButton(_ sender: UIButton) {
        
        print ("Button tapped")
    }

}

