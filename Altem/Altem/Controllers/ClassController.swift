//
//  ClassController.swift
//  Altem
//
//  Created by LabSoftware20 on 29/11/17.
//  Copyright © 2017 Danilo enrique  Diaz rios. All rights reserved.
//

import UIKit

class ClassController: UIViewController {

    @IBOutlet weak var readyImage: UIImageView!
    @IBOutlet weak var Asistencia: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if flag == 1 {
            readyImage.isHidden = false
            Asistencia.isHidden = true
        } else {
            readyImage.isHidden = true
            Asistencia.isHidden = false
        }
        // Do any additional setup after loading the view.
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
