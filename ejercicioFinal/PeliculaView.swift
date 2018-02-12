//
//  PeliculaView.swift
//  ejercicioFinal
//
//  Created by Juanito on 8/23/17.
//  Copyright © 2017 Manakle. All rights reserved.
//

import UIKit
import CoreData

var pelicula_global:Pelicula? = nil

class PeliculaView: UIViewController {

    var pelicula: Pelicula? = pelicula_global
    var imagen = ""
    var resumen = ""
    
    
    @IBOutlet var titulo: UILabel!
    
    @IBOutlet var lanzamiento: UILabel!
    
    @IBOutlet var lengua: UILabel!
    
    @IBOutlet var genero: UILabel!
    
    @IBOutlet var nota: UILabel!
    
    
    @IBOutlet var esFavorita: UISwitch!
    
    @IBOutlet var estaVista: UISwitch!
    
    
    @IBOutlet var recomendada: UITextField!
    
    @IBOutlet var miNota: UITextField!
    
    // Actualizamos los datos de pelicula
    
    @IBAction func actualizar(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pelicula")
        
        // Obtenemos la pelicula en concreto que vamos a editar
        request.predicate = NSPredicate(format: "titulo = %@", (pelicula?.titulo)!)
        
        do {
            let results = try context.fetch(request)
            
            // si la pelicula se ha encontrado en nuestra base de datos editamos sus campos
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    result.setValue(esFavorita.isOn, forKey: "favorita")
                    result.setValue(estaVista.isOn, forKey: "vista")
                    result.setValue(miNota.text, forKey: "miNota")
                    result.setValue(recomendada.text, forKey: "recomendadaPor")
                    
                }
                
                
            }
            
        } catch {
            print("Actualizacion fallida")
        }

        
        // guardar los datos
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
        

    }
 
    // Funcion para ver la imagen de la pelicula y el resumen
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPosterView" {
            let posterView = segue.destination as! PosterView
            
            posterView.imagen = imagen
            posterView.resumen = resumen
        }
    }
    
    // Insertamos los datos de la pelicula que vamos a ver/editar en los campos correspondientes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pelicula_global = pelicula
        
        // Do any additional setup after loading the view.
        
        titulo.text = pelicula!.titulo
        lanzamiento.text = pelicula?.lanzamiento
        lengua.text = pelicula?.lengua
        genero.text = pelicula?.genero
        nota.text = pelicula?.nota
        esFavorita.isOn = (pelicula?.favorita)!
        estaVista.isOn = (pelicula?.vista)!
        miNota.text = (pelicula?.miNota)!
        recomendada.text = pelicula?.recomendadaPor
        imagen = (pelicula?.imagen)!
        resumen = (pelicula?.resumen)!
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
