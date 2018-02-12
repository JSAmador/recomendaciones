//
//  ListaPelisView.swift
//  ejercicioFinal
//
//  Created by Juanito on 8/23/17.
//  Copyright © 2017 Manakle. All rights reserved.
//

import UIKit

class ListaPelisView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var pelis : [Pelicula] = []
    var verPeli: Pelicula? = nil
    @IBOutlet var tabla: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tabla.dataSource = self
        tabla.delegate = self
        
        
        
    }
    
    // Si pulsamos en una de las peliculas podremos ver y editar algunos detalles
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        verPeli = pelis[indexPath.row]
        performSegue(withIdentifier: "toPeliculaView", sender: nil)
    }
    
    // Funcion para pasar la pelicula a la vista de la pelicula
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPeliculaView" {
            let peliculaView = segue.destination as! PeliculaView
            
            peliculaView.pelicula = verPeli
                    }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        datos()
        tabla.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pelis.count
    }
    
    // Mostramos las peliculas que hemos almacenado
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celda = UITableViewCell()
        let peli = pelis[indexPath.row]

        
        // Nota dada por el usuario de la aplicacion
        
        switch (peli.miNota!) {
            case "10", "9":
                celda.textLabel?.text = "\(peli.titulo!) ★★★★★"
            case "8", "7":
                celda.textLabel?.text = "\(peli.titulo!) ★★★★☆"
            case "5", "6":
                celda.textLabel?.text = "\(peli.titulo!) ★★★☆☆"
            case "3", "4":
                celda.textLabel?.text = "\(peli.titulo!) ★★☆☆☆"
            case "1", "2":
                celda.textLabel?.text = "\(peli.titulo!) ★☆☆☆☆"
            default :
                celda.textLabel?.text = "\(peli.titulo!) ☆☆☆☆☆"
            
        }
        
        // Si ademas es favorita aniadimos el icono de corazon
        
        if peli.favorita {
            celda.textLabel?.text = "❤️ " + (celda.textLabel?.text!)!
        }
        
        // Si tambien se ha visto esta pelicula aniadiremos unas gafas
        
        if peli.vista {
            celda.textLabel?.text = "👓 " + (celda.textLabel?.text!)!

        }
        
        
        
        return celda
    }
    
    // Funcion para el borrado
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            let peli = pelis[indexPath.row]
            context.delete(peli)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
                pelis = try context.fetch(Pelicula.fetchRequest())
            } catch {
                print ("Error 2")
            }
            tabla.reloadData()
        }
    }
    
    // Extraemos los datos de la base de datos
    
    func datos() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            pelis = try context.fetch(Pelicula.fetchRequest())
            
        } catch {
            print ("Error")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
