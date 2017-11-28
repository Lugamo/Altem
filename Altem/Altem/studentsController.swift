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
var students = [Student2]()
var missing = [Missing]()
class studentsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    final let url2 = URL(string: "http://microblogging.wingnity.com/JSONParsingTutorial/jsonActors")
    
    var myToken = String()
    var individual = Student2(name: "N/A", lastname: "N/A", id: "N/A", nrc: "N/A", attendance: false)
    
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //downloadJson()
        if flag == 0{
            print(flag)
            Dologin()
        } else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        flag += 1
        
        
    }
    
    func Dologin(){
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
                            for name in all{
                                self.individual.name = String(describing:name.value(forKey: "NOMBRES")!)
                                self.individual.lastname = String(describing:name.value(forKey: "APELLIDOS")!)
                                self.individual.id = String(describing:name.value(forKey: "ID")!)
                                self.individual.nrc = String(describing:name.value(forKey: "NRC")!)
                                students.append(Student2(name: self.individual.name, lastname: self.individual.lastname, id: self.individual.id, nrc: self.individual.nrc, attendance: true))
                               
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
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell") as? StudentsCell else { return UITableViewCell() }
        
        cell.nameLabel.text = students[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let excuse = UITableViewRowAction(style: .destructive, title: "Excusa", handler: { action , indexPath in
            print("Excuse Click SuccessFully")
        })
        
        return [excuse]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            students[indexPath.row].attendance = false
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            students[indexPath.row].attendance = true
        }
    }
    @IBAction func Cancelar(_ sender: UIBarButtonItem) {
        createAlert()
    }
    
    @IBAction func Enviar(_ sender: UIBarButtonItem) {
        for i in students {
            if i.attendance == false{
                missing.append(Missing(id: i.id, nrc: i.nrc))
            }
        }
        do{
            let jsonData = try JSONEncoder().encode(missing)
            let jsonString = String(data: jsonData, encoding: .utf8)
            PostMissing(JsonPost: jsonString)
            print(jsonString!)
            let session = URLSession.shared
            guard let url = URL(string: "http://192.34.79.113/api/now/") else {return}
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/jason", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
                
                guard let _:Data = data else{
                    return
                }
            })
            task.resume()
            
            
        } catch {
            return
        }
        
        self.performSegue(withIdentifier: "ShowtoHub", sender: self)
        
    }
    func PostMissing(JsonPost: Any? ){
        guard let url = URL(string: "http://192.34.79.113/api/now/") else {return}
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        //request.httpBody = JsonPost
    }
    
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
