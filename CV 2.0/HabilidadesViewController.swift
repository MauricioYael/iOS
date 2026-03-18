import UIKit

class HabilidadesViewController: UIViewController {

    // Botón conectado desde el Storyboard
    @IBOutlet weak var buttonClickMe: UIButton!
    
    // Variable contador
    var contador = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("La vista se cargó (viewDidLoad)")
        
        // Configuración inicial del botón
        buttonClickMe.setTitle("Click me", for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("Aparecerá la vista (viewWillAppear)")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("La vista ya apareció (viewDidAppear)")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("La vista desaparecerá (viewWillDisappear)")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("La vista desapareció (viewDidDisappear)")
    }

    // Acción del botón
    @IBAction func buttonClickMePressed(_ sender: UIButton) {
        
        contador += 1
        
        buttonClickMe.setTitle("Contador \(contador)", for: .normal)
        
        print("Botón presionado \(contador) veces")
    }
}
