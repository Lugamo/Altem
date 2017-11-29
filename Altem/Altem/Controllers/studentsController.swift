//
//  studentsController.swift
//  Altem
//
//  Created by Danilo enrique  Diaz rios on 20/11/17.
//  Copyright © 2017 Danilo enrique  Diaz rios. All rights reserved.
//


import UIKit
import Foundation
var flag = 0
var students = [Student]()
var missing = [Missing]()
class studentsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var myToken = String()
    var individual = Student(name: "N/A", lastname: "N/A", id: "N/A", nrc: "N/A", attendance: false)
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DownloadStudents()
    }
    
    //funcion para realizar una peticion GET con token a la API, la cual devuelve un Json con los estudiantes de la clase actual
    func DownloadStudents(){
        
        guard let url = URL(string: "http://192.34.79.113/api/now/") else {return}
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        let completeTokenStr = myToken
        let authorizationKey = "Bearer ".appending(completeTokenStr)
        
        request.addValue(authorizationKey, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            guard let _:Data = data else{
                return
            }
            let json:Any?
            
            do{
                
                json = try JSONSerialization.jsonObject(with: data!, options: [])
                
                if let dictionary = json as? [String: Any]{
                    if let result = dictionary["data"] as? [String: Any]{
                        if let all = result["Students"] as? [NSDictionary]{
                            //para cada alumno se extraen los datos necesarios y se guardan en la clase Students
                            for name in all{
                                self.individual.name = String(describing:name.value(forKey: "NOMBRES")!)
                                self.individual.lastname = String(describing:name.value(forKey: "APELLIDOS")!)
                                self.individual.id = String(describing:name.value(forKey: "ID")!)
                                self.individual.nrc = String(describing:name.value(forKey: "NRC")!)
                                students.append(Student(name: self.individual.name, lastname: self.individual.lastname, id: self.individual.id, nrc: self.individual.nrc, attendance: true))
                               
                            }
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                return
            }
        })
        task.resume()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Numero de filas a crear
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    //Colocar los nombres de los estudiantes en cada fila
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell") as? StudentsCell else { return UITableViewCell() }
        
        cell.nameLabel.text = students[indexPath.row].name
        return cell
    }
    //funcion para el boton excusa, aun no se le ha dado funcionalidad
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let excuse = UITableViewRowAction(style: .destructive, title: "Excusa", handler: { action , indexPath in
            print("Excuse Click SuccessFully")
        })
        
        return [excuse]
    }
    //funcion para los check de los estudiantes, automaticamente se cambia el atributo attendace de cada estudiante
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            students[indexPath.row].attendance = false
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            students[indexPath.row].attendance = true
        }
    }
    //funcion para el boton cancelar
    @IBAction func Cancelar(_ sender: UIBarButtonItem) {
        createAlert()
    }
    //boton enviar el cual recorre la lista y recoge aquellos que faltaron y se agregan a un array de de Missing(Clase)
    @IBAction func Enviar(_ sender: UIBarButtonItem) {
        for i in students {
            if i.attendance == false{
                missing.append(Missing(idEstudiante: i.id, nrc: i.nrc))
            }
        }
        PostMissing(missing)
        self.performSegue(withIdentifier: "ShowtoHub", sender: self)
        flag = 1
    
    }
    //funcion para enviar a la API los estudiantes faltantes (uno por uno :/ )
    func PostMissing(_ miss:[Missing]){
        do{
            for student in miss {
                let jsonData = try JSONEncoder().encode(student)
                let jsonString = String(data: jsonData, encoding: .utf8)
                print(jsonString!)
                let request = NSMutableURLRequest(url: NSURL(string: "http://192.34.79.113/api/missing")! as URL,
                                                  cachePolicy: .useProtocolCachePolicy,
                                                  timeoutInterval: 10.0)
                request.httpMethod = "POST"
                let completeTokenStr = myToken
                let authorizationKey = "Bearer ".appending(completeTokenStr)
                request.addValue(authorizationKey, forHTTPHeaderField: "Authorization")
                request.addValue("aplication/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
                
                let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    
                    if (error != nil) {
                        print(error)
                    } else {
                        let httpResponse = response as? HTTPURLResponse
                        print(httpResponse)
                    }
                })
                
                dataTask.resume()
                
            }
        } catch {
            return
        }
    }
    
    //funcion para que aparezca un Pop Up de alerta
    func createAlert ()
    {
        
        let alert = UIAlertController(title: "Cancelar", message: "¿Seguro desea cancelar la asistencia?", preferredStyle: UIAlertControllerStyle.alert)
        let Yes = (UIAlertAction(title: "Si", style:UIAlertActionStyle.default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "ShowtoHub", sender: self)
            alert.dismiss(animated: true, completion: nil)
        }))
        let No = (UIAlertAction(title: "No", style:UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(Yes)
        alert.addAction(No)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
