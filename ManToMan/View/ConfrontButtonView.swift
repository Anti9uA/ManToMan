//
//  ConfrontButtonView.swift
//  ManToMan
//
//  Created by Kyubo Shim on 2023/02/05.
//

import SwiftUI

struct ConfrontButtonView: View {
    var body: some View {
        ZStack{
            Color.green.ignoresSafeArea()
            Rectangle()
                .cornerRadius(20)
                .frame(width: 67, height: 67)
                .foregroundColor(Color.white)
            VStack{
                Triangle()
                    .fill(.blue)
                    .frame(width: 30, height: 17, alignment: .center)
                    .rotationEffect(Angle(degrees: 180))
                Rectangle()
                    .cornerRadius(20)
                    .frame(width: 38, height: 5)
                    .foregroundColor(Color.black)
                Triangle()
                    .fill(.blue)
                    .frame(width: 42, height: 17, alignment: .center)
            }
            .padding()
        }
    }
}

struct Triangle : Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))

        return path
    }
}

struct ConfrontButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ConfrontButtonView()
    }
}
