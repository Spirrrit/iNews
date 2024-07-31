//
//  UIRefreshControl + Ext.swift
//  iNews MVVM+C
//
//  Created by Слава Васильев on 31.07.2024.
//

import UIKit

extension UIRefreshControl {
    func beginRefreshingManually() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: true)
        }
        beginRefreshing()
    }
}
