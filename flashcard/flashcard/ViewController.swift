//
//  ViewController.swift
//  flashcard
//
//  Created by Wellinston Oliveira on 27/04/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //DataSource
    let deck: Array = ["Revolução Industrial", "1ª Guerra Mundial", "2ª Guerra Mundial", "Iluminismo"]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        deck.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = deck[indexPath.row]
        return cell
    }
    
    //Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let flashCardViewController = storyboard?.instantiateViewController(withIdentifier: "flashCard") as! FlashCard
        
        navigationController?.pushViewController(flashCardViewController, animated: true)
        
    }
    @IBOutlet weak var tableView: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.dataSource = self
        tableView?.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        title = "História"
    }
}
