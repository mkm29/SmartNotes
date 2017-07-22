//
//  NotesViewController.swift
//  SmartNotes
//
//  Created by Mitchell Murphy on 7/22/17.
//  Copyright © 2017 Mitchell Murphy. All rights reserved.
//

import UIKit
import Auth0

class NotesViewController: UIViewController {

    
    var currentUser: UserInfo? {
        return AuthSessionManager.shared.profile
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let name = self.currentUser?.name {
            navigationItem.title = name
        }
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
