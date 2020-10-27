//
//  Extension.swift
//  PictureGallery
//
//  Created by Valeria Muldt on 26.10.2020.
//

import UIKit

extension UIViewController {
    func alert() {
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось отправить запрос", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
