//
//  Student.swift
//  Altem
//
//  Created by Danilo enrique  Diaz rios on 21/11/17.
//  Copyright © 2017 Danilo enrique  Diaz rios. All rights reserved.
//

import UIKit

class Students: Codable {
    //Array of students
    let actors: [Student]
    
    init(actors:[Student]) {
        self.actors = actors
    }
}

class Student: Codable {
    let name: String
    let dob: String
    let country: String
    //let asistencia: Int

    init(name: String, dob: String, country: String, asistencia: Int) {
        self.name = name
        self.dob = dob
        self.country = country
        //self.asistencia = asistencia
    }
}
