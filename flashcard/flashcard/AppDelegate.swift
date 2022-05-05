//
//  AppDelegate.swift
//  flashcard
//
//  Created by Wellinston Oliveira on 27/04/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if isNewUser() {
            let context = persistentContainer.newBackgroundContext()
            popularDeck(context: context)
            popualCards(context: context)
            setAsNotNewUser()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // Verifica se o aplicativo foi aberto pela primeira vez
    private func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    // Altera o valor booleano para informar que o usuário já abriu o app
    private func setAsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
    
    // Função para salvar alterações no Core Data
    private func saveContext(context: NSManagedObjectContext) {
        do { try context.save() } catch { print(error) }
    }
    
    // Função para criar Decks
    private func createDeck(name: String, context: NSManagedObjectContext) {
        let newDeck = Deck(context: context)
        newDeck.setValue(name, forKey: "nome")
        saveContext(context: context)
    }
    
    // Função para criar Card
    private func createCard(pergunta: String, resposta: String, id: Int, belongsTo deck: Deck, context: NSManagedObjectContext) {
        let newCard = Cartao(context: context)
        newCard.setValue(pergunta, forKey: "pergunta")
        newCard.setValue(resposta, forKey: "resposta")
        newCard.setValue(id, forKey: "id")
        
        //Criando o relacionamento com o Deck
        deck.addToCartao(newCard)
        
        saveContext(context: context)
    }
    
    // Função para puxar o Array de Decks
    private func fetchDecks(context: NSManagedObjectContext) -> [Deck] {
        let fetchRequest = Deck.fetchRequest()
        var lista: [Deck] = []
        
        do {
            lista = try context.fetch(fetchRequest)
        } catch { print(error) }
        
        return lista
    }
    
    func popularDeck(context: NSManagedObjectContext) {
        // Array com nome dos decks
        let decks: [String] = ["Revolução Industrial", "1ª Guerra Mundial", "2ª Guerra Mundial", "Iluminismo", "Não pode"]
         
        for i in decks {
            createDeck(name: i, context: context)
        }
    }
    
    private func popualCards(context: NSManagedObjectContext) {
        // Puxando os Decks que foram salvos
        let listaDecks = fetchDecks(context: context)
        
        // Matriz [[]] Pergunta e outra para Resposta
        let pergunta: [[String]] = [
            ["Quando começou a primeira Revolução Industrial?", "1+1"],
            ["Quando começou a Primeira Guerra Mundial?"],
            ["Quando começou a Segunda Guerra Mundial?"],
            ["Quando começou o o Iluminismo?"],
            ["sla"]]
        
        let resposta: [[String]] = [
            ["1760", "3"],
            ["1914"],
            ["1939"],
            ["1685"],
            ["asas"]]
        
        // Iterar cada nome de Deck
        for i in 0..<listaDecks.count {
            // Iterar cada array de pergunta e resposta
            for j in 0..<pergunta[i].count {
                createCard(pergunta: pergunta[i][j], resposta: resposta[i][j], id: i, belongsTo: listaDecks[i], context: context)
            }
        }
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*r
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "flashcard")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

