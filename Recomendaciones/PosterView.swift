//
//  PosterView.swift
//  ejercicioFinal
//
//  Created by Juanito on 8/23/17.
//  Copyright © 2017 Manakle. All rights reserved.
//

import UIKit

class PosterView: UIViewController {

    
    var imagen: String = ""
    var resumen: String = ""

   
    
    @IBOutlet var poster: UIImageView!
    
    
    // Funcion para pasar datos a la vista del resumen
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResumen" {
            let resumenView = segue.destination as! ResumenView

            resumenView.resumen = resumen
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        
        // Con la URL de la imagen que tenemos guardada obtendremos la imagen de la pelicula y la mostraremos en la pantalla
        
        guard let image_content = URL(string: imagen)
            else {
                return
        }
        
        let data = try? Data(contentsOf: image_content)
        
        if data != nil {
            
           let imagen_poster = UIImage(data: data!)
            self.poster.image = imagen_poster
        }
       
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
