//
//  ListaSeriesView.swift
//  ejercicioFinal
//
//  Created by Juanito on 8/23/17.
//  Copyright © 2017 Manakle. All rights reserved.
//

import UIKit

class ListaSeriesView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var series : [Serie] = []
    var verSerie: Serie? = nil

    @IBOutlet var tabla: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tabla.dataSource = self
        tabla.delegate = self
        
        
        
    }
    
    // Pasamos los datos de la serie a la vista para mostrarlos y editarlos
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSeriesView" {
            let seriesView = segue.destination as! seriesView
            
            seriesView.serie = verSerie
        }
    }
    
    // Si hacemos click en una serie pasaremos a la vista de datos y edicion
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        verSerie = series[indexPath.row]
        performSegue(withIdentifier: "toSeriesView", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        datos()
        tabla.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return series.count
    }
    
    // Mostramos las series en la lista
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celda = UITableViewCell()
        let serie = series[indexPath.row]
        
        if serie.estaFinalizada {
            celda.textLabel?.text = "✅  \(serie.titulo!) ⏯ \(serie.dondeVerla!)"
        } else {
            
            celda.textLabel?.text = "📆 \(serie.titulo!) ⏯ \(serie.dondeVerla!) "
        }
        
        
        return celda
    }
    
    // Funcion para eliminar una serie
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            let serie = series[indexPath.row]
            context.delete(serie)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
                series = try context.fetch(Serie.fetchRequest())
            } catch {
                print ("Error Al eliminar la serie")
            }
            tabla.reloadData()
        }
    }
    
    // Extraemos los datos de las series
    
    func datos() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            series = try context.fetch(Serie.fetchRequest())
            
        } catch {
            print ("Error al devolver datos")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

