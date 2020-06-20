//
//  Event.swift
//  MyCalendarApp
//

import Foundation
import RealmSwift

class Event: Object {
    
    @objc dynamic var date: String = ""
    @objc dynamic var event: String = ""
    
}
