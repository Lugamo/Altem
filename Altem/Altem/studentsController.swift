//
//  studentsController.swift
//  Altem
//
//  Created by Danilo enrique  Diaz rios on 20/11/17.
//  Copyright © 2017 Danilo enrique  Diaz rios. All rights reserved.
//


import UIKit

var flag = 0
class studentsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    final let url2 = URL(string: "http://microblogging.wingnity.com/JSONParsingTutorial/jsonActors")
    var myToken = String()
    private var students = [Student]()
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        downloadJson()
        Dologin()
        
    }
    
    func Dologin(){
        let url = URL(string: "http://192.34.79.113/api/now/")
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url!)
        let completeTokenStr = String(describing:token!)
        print(completeTokenStr)
        let authorizationKey = "Bearer ".appending(completeTokenStr)
        
        //let paramToSend = "code=" + user + "&password=" + psw
        
        //request.httpBody = paramToSend.data(using: String.Encoding.utf8)
        
        request.addValue(authorizationKey, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            //print("****** response = \(response)")
            //let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //print("********* response data = \(responseString)")
            guard let _:Data = data else{
                return
            }
            let json:Any?
            
            do{
                json = try JSONSerialization.jsonObject(with: data!, options: [])
                print(json)
            } catch {
                return
            }
            
            guard let server_response = json as? NSDictionary else
            {
                return
            }
            
        })
        task.resume()
    }
    
    
    
    
    
    @IBAction func studentSwitch(_ sender: UISwitch) {
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadJson(){
        guard let downloadURL = url2 else { return }
        URLSession.shared.dataTask(with: downloadURL) { data, URLResponse, error in
            
            guard let data = data, error == nil, URLResponse != nil else {
                print("somethin wrong")
                return
            }
            print("Downloaded")
            do{
                let decoder = JSONDecoder()
                let downloadedStudents = try decoder.decode(Students.self, from: data)
                self.students = downloadedStudents.actors
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch {
                print("something wrong after downloaded")
            }
        }.resume()
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
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            print(students[indexPath.row].name)
        }
    }
    @IBAction func Cancelar(_ sender: UIBarButtonItem) {
        createAlert()
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
