//
//  UIImage.swift
//  GundyMarket
//
//  Created by Gundy on 4/22/24.
//

import UIKit

extension UIImage {
    func resize(_ maxLength: CGFloat) -> UIImage {
        let longSide = max(size.width, size.height)
        let scale = maxLength / longSide
        let size = CGSize(width: size.width * scale, height: size.height * scale)
        let render = UIGraphicsImageRenderer(size: size)
        let image = render.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        
        return image
    }
}
