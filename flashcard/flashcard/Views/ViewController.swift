import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //DataSource
    var deck: [Deck] = []
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        deck.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = deck[indexPath.row].nome
        return cell
    }
    
    //Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let flashCardViewController = storyboard?.instantiateViewController(withIdentifier: "flashCard") as! FlashCard
        
        flashCardViewController.selectedDeck = deck[indexPath.row]
        navigationController?.pushViewController(flashCardViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.deck = fetchDecks()
        
        tableView?.contentInsetAdjustmentBehavior = .never
        tableView?.dataSource = self
        tableView?.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "História"
    }
    
    //Puxar dados no CoreData
    private func fetchDecks() -> [Deck] {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Deck.fetchRequest()
        
        var list: [Deck] = []
        
        do {
            list = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        return list
    }
}
