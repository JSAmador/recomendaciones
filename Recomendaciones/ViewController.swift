//
//  ViewController.swift
//  ejercicioFinal
//
//  Created by Juanito on 8/22/17.
//  Copyright © 2017 Manakle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    var imagen: String = ""
    var resumen: String = ""
    let apiKey = "4c9901ef14699d35726aca0af69b316f"
    var poster: UIImage?
    var existe: Bool = false
    
    @IBOutlet var pelicula: UITextField!
    @IBOutlet var titulo: UILabel!
    @IBOutlet var lanzamiento: UILabel!
    @IBOutlet var lengua: UILabel!
    @IBOutlet var genero: UILabel!
    @IBOutlet var nota: UILabel!
    @IBOutlet var favorita: UISwitch!
    @IBOutlet var vista: UISwitch!
    @IBOutlet var recomendada: UITextField!
    @IBAction func buscar(_ sender: UIButton) {
        

        // Utilizamos la cadena insertada en el campo pelicula para realizar la busqueda
        let peli_unformatted = pelicula.text!
        
        
        // Comprboamos que se ha introducido un titulo antes de realizar la busqueda
        if (peli_unformatted != "") {
            
            // Quitamos los espacios en blanco o saltos de linea al principio y al final
            let peli_trimed = peli_unformatted.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Formateamos la cadena para que sea legible por la API *ver funcion mas abajo
            let peli = formatPeli(string: peli_trimed)
            
            // Realizamos la peticion a la Pagina
            
            let apiURL = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(peli)"
            
            // Comprobamos los datos obtenidos
            
            
            guard let url = URL(string: apiURL)
                else {
                    return
            }
            
            guard let data = try? Data(contentsOf: url)
                else {
                    print("Error En request from API")
                    return
            }
            
            // Sacamos la informacion del archivo JSON obtenido
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                
                
                
                let movie_results: NSArray = (json!["results"] as? NSArray)!
                
                // Comprobamos que la busqueda produce resultados
                if(movie_results.count == 0) {
                    self.titulo.text = "Pelicula no encontrada"
                    self.nota.text = "0"
                    
                } else {
                    // Actualizamos la variable para que solo almacene resultados si la pelicula existe
                    existe = true
                    
                    let movie: NSDictionary = movie_results[0] as! NSDictionary
                    
                    let pelicula_id  = Int(movie["id"] as! Int)
                    let titulo_pelicula = movie["title"] as? String
                    let nota = movie["vote_average"] as! Double
                    let poster_path = movie["poster_path"] as! String
                    
                    let release = movie["release_date"] as! String
                    
                    let lenguaje = movie["original_language"] as! String
                    
                    
                    // Debemos hacer una segunda peticion para extraer los generos de la pelicula
                    let genero = generos(peli_id: pelicula_id)
                    
                    resumen = movie["overview"] as! String
                    
                    
                    // Convertimos la nota obtenida a String para representarlo
                    let resultado = "Nota: \(String(describing: nota))"
                    
                    self.nota.text = resultado
                    self.titulo.text = titulo_pelicula
                    self.lanzamiento.text = "Lanzamiento: \(release)"
                    self.lengua.text = "Lenguaje: \(lenguaje)"
                    self.genero.text = genero
                    
                    // Obtenemos la imagen de la pelicula para almacenar la URL en la base de datos
                    let image_url = "https://image.tmdb.org/t/p/w500\(String(describing: poster_path))"
                    
                    imagen = image_url
                    
                }
                
                
                
                
            } catch {
                print ("Error2")
            }
            
        // Si se ha dejado el titulo en blanco, recordamos al usuario que el titulo es obligatorio
        } else {
            pelicula.placeholder = "El titulo es obligatorio"
            pelicula.layer.borderColor = (UIColor.red).cgColor
            pelicula.layer.borderWidth = 1.0
        }
        
        
    }


    
  
    // Guardamos los datos una vez hayamos tenido una busqueda exitosa
    
    @IBAction func guardar(_ sender: UIButton) {
        
        // Si la busqueda no ha dado resultados y la pelicula no existe mostramos una alerta indicandolo
        if (existe == false) {
            
            let alert = UIAlertController(title: "Pelicula no encontrada", message: "No puedes guardar una pelicula que no existe", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction((UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil)))
            self.present(alert, animated: true, completion: nil)
        
            
        // De lo contrario guardamos los detalles de la pelicula que necesitamos
        } else {
        
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let peli = Pelicula(context: context)
            peli.titulo = titulo.text!
            peli.lanzamiento = lanzamiento.text!
            peli.lengua = lengua.text!
            peli.genero = genero.text!
            peli.nota = nota.text!
            peli.favorita = favorita.isOn
            peli.vista = vista.isOn
            peli.recomendadaPor = recomendada.text!
            peli.imagen = imagen
            peli.resumen = resumen
            peli.miNota = ""
        
        
            // guardar los datos
        
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            navigationController?.popViewController(animated: true)
        }

        
    }
// Esta funcion da formato a la cadena insertada en el campo pelicula, aniadiendo el simbolo + entre cada palabra

func formatPeli(string: String) -> String {
    
    let string_array = string.characters.split{$0 == " "}.map(String.init)
    var result:String = string_array[0]
    
    for index in 1..<(string_array.count) {
        result = result + "+" + string_array[index]
    }
    return result
}
    
    // Funcion para extraer los generos de la pelicula haciendo una segunda llamada a la API y devolvemos los resultados en forma de String
    
    func generos(peli_id:  Int) -> String {
        
        var todos_generos: String = ""
        var cat:String
        // Hacemos la llamada con el id de la pelicula
        let generos_url = "https://api.themoviedb.org/3/movie/\(peli_id)?api_key=4c9901ef14699d35726aca0af69b316f"
        
        guard let url_g = URL(string: generos_url)
            else {
                return "No se ha podido recuperar los generos"
        }
        
        guard let data_g = try? Data(contentsOf: url_g)
            else {
                print("Error En request from API en generos")
                return "No dispone de generos"
        }
        do {
            let json_g = try JSONSerialization.jsonObject(with: data_g, options: .mutableContainers) as? NSDictionary
            

            let genres: NSArray = (json_g!["genres"] as? NSArray)!
            
            
            
            // Comprobamos que la busqueda produce resultados
            if(genres.count == 0) {
                self.genero.text = "No dispone de generos"
            } else {
                for categoria in genres {
                    let category: NSDictionary = categoria as! NSDictionary
                    cat = category["name"] as! String
                    todos_generos = todos_generos  + cat + " "
                }
                
            }
            
            
        } catch {
            print ("Error: Generos no accesibles")
        }
        
        return todos_generos


    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

