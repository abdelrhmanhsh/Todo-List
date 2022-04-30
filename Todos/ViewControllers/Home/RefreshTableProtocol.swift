//
//  RefreshTableProtocol.swift
//  Todos
//
//  Created by Abdelrhman Ahmed on 25/04/2022.
//

import Foundation
import CoreData

protocol RefreshTableProtocol {
    
    func refreshTableAndApped(todo: Todo?)
    func refreshTable()
    
}
