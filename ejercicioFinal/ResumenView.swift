//
//  ResumenView.swift
//  ejercicioFinal
//
//  Created by Juanito on 8/23/17.
//  Copyright © 2017 Manakle. All rights reserved.
//

import UIKit

class ResumenView: UIViewController {
    
    var resumen = ""

    @IBOutlet var texto: UITextView!
    

    // Mostramos el resumen de la pelicula que tenemos lamacenado
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        texto.text = resumen
        
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
