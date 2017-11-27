//
//  RobinhoodOrder.swift
//  FreeLunch
//
//  Created by Johns Gresham on 11/26/17.
//  Copyright © 2017 Johns Gresham. All rights reserved.
//

import UIKit
import os.log

class RobinhoodOrder: NSObject, NSCoding {
    //MARK: Properties
    
    var orderDate: Date
    var side: String
    var price: String
    var instrument: String
    var quantity: String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("orders")
    
    //MARK: Types
    struct PropertyKey {
        static let orderDate = "orderDate"
        static let side = "side"
        static let price = "price"
        static let instrument = "instrument"
        static let quantity = "quantity"
    }
    
    //MARK: Methods
    init?(orderDate: Date, side: String, price: String, instrument: String, quantity: String) {
        
        // The name must not be empty
        guard (!side.isEmpty) || (!price.isEmpty) || (!instrument.isEmpty) || (!quantity.isEmpty) else {
            return nil
        }
        
        // Initialize stored properties.
        self.orderDate = orderDate
        self.side = side
        self.price = price
        self.instrument = instrument
        self.quantity = quantity
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(orderDate, forKey: PropertyKey.orderDate)
        aCoder.encode(side, forKey: PropertyKey.side)
        aCoder.encode(price, forKey: PropertyKey.price)
        aCoder.encode(instrument, forKey: PropertyKey.instrument)
        aCoder.encode(quantity, forKey: PropertyKey.quantity)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let orderDate = aDecoder.decodeObject(forKey: PropertyKey.orderDate) as? Date else {
            os_log("Unable to decode the order date for an Order object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let side = aDecoder.decodeObject(forKey: PropertyKey.side) as? String else {
            os_log("Unable to decode the side for an Order object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let price = aDecoder.decodeObject(forKey: PropertyKey.price) as? String else {
            os_log("Unable to decode the price for an Order object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let instrument = aDecoder.decodeObject(forKey: PropertyKey.instrument) as? String else {
            os_log("Unable to decode the instrument for an Order object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let quantity = aDecoder.decodeObject(forKey: PropertyKey.quantity) as? String else {
            os_log("Unable to decode the quantity for an Order object.", log: OSLog.default, type: .debug)
            return nil
        }
        // Must call designated initializer.
        self.init(orderDate: orderDate, side: side,price: price, instrument: instrument, quantity: quantity)
    }
}
