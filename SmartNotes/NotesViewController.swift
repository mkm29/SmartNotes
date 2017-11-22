//
//  NotesViewController.swift
//  SmartNotes
//
//  Created by Mitchell Murphy on 7/22/17.
//  Copyright © 2017 Mitchell Murphy. All rights reserved.
//

import UIKit
import CoreData
import Auth0

class NotesViewController: UIViewController {

    
    var currentUser: UserInfo? {
        return AuthSessionManager.shared.profile
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Note> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // fire off a fetch
        do {
            try self.fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch let error {
            print(error.localizedDescription)
        }
        
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


extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let notes = fetchedResultsController.fetchedObjects else { return 0 }
        return notes.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell") else {
            fatalError("Unexpected Index Path")
        }
        
        
        let note = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = note.title
        
        cell.detailTextLabel?.text = note.location?.name
        
        return cell
    }
    
    
}


extension NotesViewController: NSFetchedResultsControllerDelegate {
    
    
    
    
    
}
