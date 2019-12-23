//
//  ViewController+Extension.swift
//  GoogleBooks
//
//  
//

import UIKit

extension UIViewController {
    func goToDetail(with vm: ViewModel) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.viewModel = vm
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
