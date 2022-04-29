//
//  ViewController.swift
//  flashcard
//
//  Created by Wellinston Oliveira on 27/04/22.
//

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
        
//        createAll()
        self.deck = fetchDecks()
        
        tableView?.dataSource = self
        tableView?.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        title = "História"
    }
    
    //Armazenar dados no CoreData
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
    
    private func createAll() {
        // Acessar a fil AppDelegate.swift
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        // Pegar o acesso com o Core Data
        let context = appDelegate.persistentContainer.viewContext
        
        // Criar um Deck no Core Data
        let newDeck = Deck(context: context)
        
        newDeck.setValue("Revolução Industrial", forKey: "nome")
        
        createCard(deck: newDeck, context: context)
    }
    
    private func createCard(deck: Deck, context: NSManagedObjectContext) {
        let newCartao = Cartao(context: context)
        //chave e atribbuto
        newCartao.setValue(1, forKey: "id")
        newCartao.setValue("Quando começou a primeira Revolução Industrial?", forKey: "perguntas")
        newCartao.setValue("1760", forKey: "respostas")
        
        deck.addToCartao(newCartao)
        
        saveContext(context: context)
    }
    
    //func salvar no Core Data
    private func saveContext(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch { print(error) }
    }
}
