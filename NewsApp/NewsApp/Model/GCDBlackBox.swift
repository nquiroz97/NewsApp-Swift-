//
//  GCDBlackBox.swift
//  NewsApp
//
//  Created by Neri Quiroz on 1/6/21.
//

import Foundation
func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
