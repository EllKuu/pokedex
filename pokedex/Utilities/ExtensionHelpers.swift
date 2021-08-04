//
//  ExtensionHelpers.swift
//  pokedex
//
//  Created by elliott kung on 2021-08-03.
//

import Foundation
import UIKit


enum pokemonTypesList {
    case normal
    case fire
    case water
    case electric
    case grass
    case ice
    case fighting
    case poison
    case ground
    case flying
    case psychic
    case bug
    case rock
    case ghost
    case dragon
    case dark
    case steel
    case fairy
}



// UIView gradient borders

extension UIView {
    
    private static let kLayerNameGradientBorder = "GradientBorderLayer"

        func gradientBorder(width: CGFloat,
                            colors: [UIColor],
                            startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
                            endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0),
                            andRoundCornersWithRadius cornerRadius: CGFloat = 0) {

            let existingBorder = gradientBorderLayer()
            let border = existingBorder ?? CAGradientLayer()
            border.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y,
                                  width: bounds.size.width + width, height: bounds.size.height + width)
            border.colors = colors.map { return $0.cgColor }
            border.startPoint = startPoint
            border.endPoint = endPoint

            let mask = CAShapeLayer()
            let maskRect = CGRect(x: bounds.origin.x + width/2, y: bounds.origin.y + width/2,
                                  width: bounds.size.width - width, height: bounds.size.height - width)
            mask.path = UIBezierPath(roundedRect: maskRect, cornerRadius: cornerRadius).cgPath
            mask.fillColor = UIColor.clear.cgColor
            mask.strokeColor = UIColor.white.cgColor
            mask.lineWidth = width

            border.mask = mask

            let exists = (existingBorder != nil)
            if !exists {
                layer.addSublayer(border)
            }
        }
        private func gradientBorderLayer() -> CAGradientLayer? {
            let borderLayers = layer.sublayers?.filter { return $0.name == UIView.kLayerNameGradientBorder }
            if borderLayers?.count ?? 0 > 1 {
                fatalError()
            }
            return borderLayers?.first as? CAGradientLayer
        }
    
}

public extension CGPoint {

    enum CoordinateSide {
        case topLeft, top, topRight, right, bottomRight, bottom, bottomLeft, left
    }

    static func unitCoordinate(_ side: CoordinateSide) -> CGPoint {
        switch side {
        case .topLeft:      return CGPoint(x: 0.0, y: 0.0)
        case .top:          return CGPoint(x: 0.5, y: 0.0)
        case .topRight:     return CGPoint(x: 1.0, y: 0.0)
        case .right:        return CGPoint(x: 0.0, y: 0.5)
        case .bottomRight:  return CGPoint(x: 1.0, y: 1.0)
        case .bottom:       return CGPoint(x: 0.5, y: 1.0)
        case .bottomLeft:   return CGPoint(x: 0.0, y: 1.0)
        case .left:         return CGPoint(x: 1.0, y: 0.5)
        }
    }
}


extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
