//
//  seriesView.swift
//  ejercicioFinal
//
//  Created by Juanito on 8/23/17.
//  Copyright © 2017 Manakle. All rights reserved.
//

import UIKit
import CoreData

class seriesView: UIViewController {

    var serie: Serie? = nil
    
    
    @IBOutlet var titulo: UILabel!
    
    
    @IBOutlet var temporadas: UITextField!
    
    
    @IBOutlet var temporadaActual: UITextField!
    
    @IBOutlet var miNota: UITextField!
    
    @IBOutlet var estaFinalizada: UISwitch!
    
    
    @IBOutlet var dondeVerla: UITextField!
    
    @IBOutlet var recomendadaPor: UITextField!
    
    // Funcion para actualizar los datos de una serie
    
    @IBAction func actualizarEdicionSerie(_ sender: UIButton) {
        
        
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Serie")
        
        // Obtenemos la serie que vamos a actualizar desde la base de datos
        
        request.predicate = NSPredicate(format: "titulo = %@", (serie?.titulo)!)
        
        do {
            let results = try context.fetch(request)
            
            // Si la serie existe actualizamos sus campos
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    result.setValue(temporadas.text, forKey: "temporadas")
                    result.setValue(temporadaActual.text, forKey: "tempActual")
                    result.setValue(miNota.text, forKey: "miNota")
                    result.setValue(estaFinalizada.isOn, forKey: "estaFinalizada")
                    result.setValue(recomendadaPor.text, forKey: "recomendada")
                    result.setValue(dondeVerla.text, forKey: "dondeVerla")
                    
                }
               
                
            }
            
        } catch {
            print("Actualizacion fallida")
        }
  
 
       // guardar los datos
       
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
        

        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        // Inicializamos la vista con el contenido de la serie
        titulo.text = serie?.titulo
        temporadas.text = serie?.temporadas
        temporadaActual.text = serie?.tempActual
        miNota.text = serie?.miNota
        estaFinalizada.isOn = (serie?.estaFinalizada)!
        recomendadaPor.text = serie?.recomendada
        dondeVerla.text = serie?.dondeVerla
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
