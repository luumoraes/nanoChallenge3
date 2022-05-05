//
//  Cartao+CoreDataProperties.swift
//  flashcard
//
//  Created by Wellinston Oliveira on 28/04/22.
//
//

import Foundation
import CoreData


extension Cartao {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cartao> {
        return NSFetchRequest<Cartao>(entityName: "Cartao")
    }

    @NSManaged public var resposta: String?
    @NSManaged public var pergunta: String?
    @NSManaged public var id: Int64
    @NSManaged public var deck: Deck?

}

extension Cartao : Identifiable {

}
