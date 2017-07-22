//
//  Coordinator.swift
//  SmartNotes
//
//  Created by Mitchell Murphy on 7/22/17.
//  Copyright © 2017 Mitchell Murphy. All rights reserved.
//

import Auth0

class Coordinator: NSObject {
    
    
    private let _stack = CoreDataStack()
    
    private let auth = AuthSessionManager.shared
    
    
    private var _user: User? = nil
    
    
    
    
}
