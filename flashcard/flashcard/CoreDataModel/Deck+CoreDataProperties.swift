//
//  Deck+CoreDataProperties.swift
//  flashcard
//
//  Created by Wellinston Oliveira on 28/04/22.
//
//

import Foundation
import CoreData


extension Deck {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Deck> {
        return NSFetchRequest<Deck>(entityName: "Deck")
    }

    @NSManaged public var nome: String?
    @NSManaged public var historico: [Historico]?
    @NSManaged public var cartao: [Cartao]?

}

// MARK: Generated accessors for historico
extension Deck {

    @objc(insertObject:inHistoricoAtIndex:)
    @NSManaged public func insertIntoHistorico(_ value: Historico, at idx: Int)

    @objc(removeObjectFromHistoricoAtIndex:)
    @NSManaged public func removeFromHistorico(at idx: Int)

    @objc(insertHistorico:atIndexes:)
    @NSManaged public func insertIntoHistorico(_ values: [Historico], at indexes: NSIndexSet)

    @objc(removeHistoricoAtIndexes:)
    @NSManaged public func removeFromHistorico(at indexes: NSIndexSet)

    @objc(replaceObjectInHistoricoAtIndex:withObject:)
    @NSManaged public func replaceHistorico(at idx: Int, with value: Historico)

    @objc(replaceHistoricoAtIndexes:withHistorico:)
    @NSManaged public func replaceHistorico(at indexes: NSIndexSet, with values: [Historico])

    @objc(addHistoricoObject:)
    @NSManaged public func addToHistorico(_ value: Historico)

    @objc(removeHistoricoObject:)
    @NSManaged public func removeFromHistorico(_ value: Historico)

    @objc(addHistorico:)
    @NSManaged public func addToHistorico(_ values: NSOrderedSet)

    @objc(removeHistorico:)
    @NSManaged public func removeFromHistorico(_ values: NSOrderedSet)

}

// MARK: Generated accessors for cartao
extension Deck {

    @objc(insertObject:inCartaoAtIndex:)
    @NSManaged public func insertIntoCartao(_ value: Cartao, at idx: Int)

    @objc(removeObjectFromCartaoAtIndex:)
    @NSManaged public func removeFromCartao(at idx: Int)

    @objc(insertCartao:atIndexes:)
    @NSManaged public func insertIntoCartao(_ values: [Cartao], at indexes: NSIndexSet)

    @objc(removeCartaoAtIndexes:)
    @NSManaged public func removeFromCartao(at indexes: NSIndexSet)

    @objc(replaceObjectInCartaoAtIndex:withObject:)
    @NSManaged public func replaceCartao(at idx: Int, with value: Cartao)

    @objc(replaceCartaoAtIndexes:withCartao:)
    @NSManaged public func replaceCartao(at indexes: NSIndexSet, with values: [Cartao])

    @objc(addCartaoObject:)
    @NSManaged public func addToCartao(_ value: Cartao)

    @objc(removeCartaoObject:)
    @NSManaged public func removeFromCartao(_ value: Cartao)

    @objc(addCartao:)
    @NSManaged public func addToCartao(_ values: NSOrderedSet)

    @objc(removeCartao:)
    @NSManaged public func removeFromCartao(_ values: NSOrderedSet)

}

extension Deck : Identifiable {

}
