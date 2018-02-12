//
//  NuevaSerieView.swift
//  ejercicioFinal
//
//  Created by Juanito on 8/23/17.
//  Copyright © 2017 Manakle. All rights reserved.
//

import UIKit

class NuevaSerieView: UIViewController {

   
    
    @IBOutlet var titulo: UITextField!
    
    @IBOutlet var temporadas: UITextField!
    
    @IBOutlet var estaFinalizada: UISwitch!
    
    @IBOutlet var dondeVerla: UITextField!
    
    @IBOutlet var recomendada: UITextField!
    

    @IBAction func guardarSerie(_ sender: UIButton) {
        let contenidoTitulo = titulo.text!
        
        // comprobamos que se ha introducido un titulo y si es asi, guardamos los datos que hemos introducido
        
        if (contenidoTitulo != "") {
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let serie = Serie(context: context)
            serie.titulo = titulo.text!
            serie.recomendada = recomendada.text!
            serie.temporadas = temporadas.text!
            serie.dondeVerla = dondeVerla.text!
            serie.estaFinalizada = estaFinalizada.isOn
            
            
            
            
            // guardar los datos
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            navigationController?.popViewController(animated: true)

        } else {
            titulo.placeholder = "El titulo es obligatorio"
            titulo.layer.borderColor = (UIColor.red).cgColor
            titulo.layer.borderWidth = 1.0
        }
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
