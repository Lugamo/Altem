//
//  ViewController.swift
//  Altem
//
//  Created by Danilo enrique  Diaz rios on 20/11/17.
//  Copyright © 2017 Danilo enrique  Diaz rios. All rights reserved.
//

import UIKit
import Foundation


var codeTeacher = String()
var nameTeacher = String()

class ViewController: UIViewController {
    
    @IBOutlet weak var logProblems: UILabel!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    var flag = String()
    var token:Any?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        logProblems.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Boton de login, se espera a que se descargue y se extraiga el token del Json recibido
    @IBAction func LoginBtn(_ sender: UIButton) {
        
        if usernameTextField.text!.isEmpty {
            logProblems.text = "Usuario Vacio"
            logProblems.isHidden = false
            UIView.animate(withDuration: 3.5, animations: { () -> Void in
                self.logProblems.alpha = 0
            })
        } else if passwordTextField.text!.isEmpty {
            logProblems.text = "Contraseña vacia"
            logProblems.isHidden = false
            UIView.animate(withDuration: 3.5, animations: { () -> Void in
                self.logProblems.alpha = 0
            })
        } else {
            let username = usernameTextField.text
            let password = passwordTextField.text
            Dologin(String(describing: username!), String(describing: password!))
            if token != nil{
                if String(describing: token!) != "" {
                    //paso a la siguiente pantalla conectada por "segue"
                    performSegue(withIdentifier: "segue", sender: self)
                }
            }
            
        }
        
    }

    //funcion necesaria para enviar datos entre controladores
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if token != nil{
        let navc = segue.destination as! UINavigationController
            let listController = navc.viewControllers.first as! studentsController
            listController.myToken = String(describing: token!)
            }
        
    }
    
    //funcion que realiza el proceso de descarga y manejo del Json que devuelve la API
    func Dologin(_ user:String, _ psw:String){
        let url = URL(string: "http://192.34.79.113/api/login/")
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let paramToSend = "code=" + user + "&password=" + psw
        
        request.httpBody = paramToSend.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
        (data, response, error) in
            
            guard let _:Data = data else{
                return
            }
            let json:Any?
            
            do{
                json = try JSONSerialization.jsonObject(with: data!, options: [])
                //Una vez obtenido el Json se extrae la informacion necesaria
                if let dictionary = json as? [String: Any]{
                    if let result = dictionary["result"] as? [String: Any]{
                        self.token = result["token"]
                        if let codigo = result["user"] as? [String: Any]{
                            codeTeacher = String(describing: codigo["code"]!)
                            nameTeacher = String(describing: codigo["fullName"]!)
                        }
                        
                    }
                }
            } catch {
                return
            }
            
        
        })
        task.resume()
}
}



