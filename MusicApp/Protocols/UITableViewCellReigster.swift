//
//  UICellRegister.swift
//  NewMusicApp
//
//  Created by 이준복 on 2023/02/21.
//

import UIKit

protocol UITableViewCellReigster {
    static var cellId: String { get }
    static var isFromNib: Bool { get }
    
    static func register(target: UITableView)
    static func dequeueReusableCell(target: UITableView, indexPath: IndexPath?) -> Self
}


extension UITableViewCellReigster where Self: UITableViewCell {
    static func register(target: UITableView) {
        if self.isFromNib {
            target.register(UINib(nibName: self.cellId, bundle: nil), forCellReuseIdentifier: self.cellId)
        } else {
            target.register(Self.self, forCellReuseIdentifier: self.cellId)
        }
    }
    
    static func dequeueReusableCell(target: UITableView, indexPath: IndexPath?) -> Self {
        
        var cell: UITableViewCell?
        
        if let indexPath = indexPath {
            cell = target.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath)
        } else {
            cell = target.dequeueReusableCell(withIdentifier: self.cellId)
        }
        
        guard let cell = cell as? Self else { fatalError("Error! \(self.cellId)" ) }
        
        return cell
    }
}
