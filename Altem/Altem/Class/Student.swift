//
//  Student.swift
//  Altem
//
//  Created by Danilo enrique  Diaz rios on 21/11/17.
//  Copyright © 2017 Danilo enrique  Diaz rios. All rights reserved.
//

import UIKit



class Student{
    var name: String
    var lastname: String
    var id: String
    var nrc: String
    var attendance: Bool
    
    init(name: String, lastname: String, id:String, nrc: String, attendance: Bool) {
        self.name = name
        self.lastname = lastname
        self.id = id
        self.nrc = nrc
        self.attendance = false
    }
}

class Missing: Codable{
    var idEstudiante: String
    var nrc: String
    
    init(idEstudiante:String, nrc: String) {
        self.idEstudiante = idEstudiante
        self.nrc = nrc
    }
}
