//
//  Coordinator.swift
//  SmartNotes
//
//  Created by Mitchell Murphy on 7/22/17.
//  Copyright © 2017 Mitchell Murphy. All rights reserved.
//

import Auth0
import CoreLocation

class Coordinator: NSObject {
    
    
    private let _stack = CoreDataStack()
    
    private let _auth = AuthSessionManager.shared
    
    private var _user: User? = nil
    
    private let locationManager = CLLocationManager()
    
    var auth: AuthSessionManager {
        return self._auth
    }

    
    var currentUser: User? {
        return self._user
    }
    
    override init() {
        super.init()
        print((UIApplication.shared.delegate as! AppDelegate).getLibraryDirectory())
        //self.createTestData()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    
    
    private func createTestData() {
        // User
        let newUser = User(context: self._stack.context)
        newUser.firstName = "Mitch"
        newUser.lastName = "Murphy"
        newUser.email = "mitch.murphy@gmail.com"
        newUser.pictureURL = "https://lh6.googleusercontent.com/-wvejvIO1uc4/AAAAAAAAAAI/AAAAAAAAFoI/-Q1JBSzka84/photo.jpg"
        
        
        
        // Provider
        let newProvider = Provider(context: self._stack.context)
        newProvider.id = "102970342238349120508"
        newProvider.type = "google-oauth2"
        
        
        newProvider.user = newUser
        newUser.providers?.adding(newProvider)
        
        
        self.createTestNotes(forUser: newUser)
        
        
        
        
        self._stack.saveContext()
    }
    
    private func createTestNotes(forUser user: User) {
        
        if let user = self._stack.retrieveUser(withEmail: "mitch.murphy@gmail.com") {
            
        }
        
    }
    
}
