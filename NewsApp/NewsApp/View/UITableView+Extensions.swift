//
//  UITableView+Extensions.swift
//  NewsApp
//
//  Created by Neri Quiroz on 1/9/21.
//

import UIKit

extension UITableView {
    func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
        guard let lastIndexPath = indexPathsForVisibleRows?.last else {
            return false
        }

        return lastIndexPath == indexPath
    }
}
