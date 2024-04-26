//
//  ShapeFactory.swift
//  Set
//
//  Created by Arnab Sen on 05/04/24.
//

import SwiftUI

struct ShapeFactory {
    
    private init() {}
        
    protocol ShapeDrawProperties {
        var fillType: SetCard.ColorFillType { get }
        var color: SetCard.Color { get }
    }
    
    // MARK: Singleton "drawn" custom shapes
    struct Diamond: Shape {
        func path(in rect: CGRect) -> Path {
            Path { path in
                let startPoint = CGPoint(x: rect.midX, y: rect.minY)
                path.move(to: startPoint)
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
                path.addLine(to: startPoint)
            }
        }
    }

    struct Squiggle: Shape {
        func path(in rect: CGRect) -> Path {
            Path { path in
                
                // Curve 1
                let point1 = CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.4)
                let point2 = CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.2)
                let control1 = CGPoint(x: rect.width * 0.25, y: -rect.height * 0.2)
                
                // Curve 2
                let point3 = CGPoint(x: rect.maxX, y: rect.minY)
                let control2 = CGPoint(x: rect.width * 0.75, y: rect.midY + rect.height * 0.2)
                
                // Curve 3
                let point4 = CGPoint(x: rect.maxX, y: rect.maxY - rect.height * 0.4)
                let point5 = CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.2)
                let control3 = CGPoint(x: rect.width * 0.75, y: rect.height * 1.4)
                
                // Curve 4
                let point6 = CGPoint(x: rect.minX, y: rect.maxY)
                let control4 = CGPoint(x: rect.width * 0.25, y: rect.midY - rect.height * 0.2)
                
                // Join Everything!
                path.move(to: point1)
                path.addQuadCurve(to: point2, control: control1)
                path.addQuadCurve(to: point3, control: control2)
                path.addLine(to: point4)
                path.addQuadCurve(to: point5, control: control3)
                path.addQuadCurve(to: point6, control: control4)
                path.addLine(to: point1)
            }
        }
    }
    
    struct RoundedRectrangle: Shape {
        
        func path(in rect: CGRect) -> Path {
            Path { path in
                
                let point1 = CGPoint(x: rect.minX + rect.width * 0.2, y: rect.minY)
                let point2 = CGPoint(x: rect.maxX - rect.width * 0.2, y: rect.minY)
                
                let point3 = CGPoint(x: point2.x, y: rect.maxY)
                let control1 = CGPoint(x: rect.maxX + rect.width * 0.2, y: rect.midY)
                
                let point4 = CGPoint(x: point1.x, y: rect.maxY)
                let control2 = CGPoint(x: -rect.width * 0.20, y: rect.midY)
                
                path.move(to: point1)
                path.addLine(to: point2)
                path.addQuadCurve(to: point3, control: control1)
                path.addLine(to: point4)
                path.addQuadCurve(to: point1, control: control2)
            }
        }
    }
    
}

