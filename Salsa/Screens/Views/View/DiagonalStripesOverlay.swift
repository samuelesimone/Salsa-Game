//
//  DiagonalStripesOverlay.swift
//  Salsa
//
//  Created by Samuele Simone on 26/04/25.
//

import SwiftUI

struct DiagonalStripesOverlay: View {

    var stripeWidth: CGFloat = 6
       var colors: [Color] = [.red, .white]

       var body: some View {
           GeometryReader { geometry in
               let size = geometry.size
               let diagonal = sqrt(size.width * size.width + size.height * size.height)  // Calcola la diagonale della cella
               let stripesNeeded = Int(diagonal / stripeWidth) + 2  // Numero di strisce necessarie

               ZStack {
                   ForEach(0..<stripesNeeded, id: \.self) { i in
                       colors[i % colors.count]
                           .frame(width: stripeWidth, height: diagonal)
                           .position(x: CGFloat(i) * stripeWidth, y: diagonal / 2)
                   }
               }
               .frame(width: size.width, height: size.height)
               .rotationEffect(.degrees(45))  // Ruotiamo le strisce
               .clipped()  // Ritaglia il contenuto che esce dai bordi
           }
       }
    }

#Preview {
    DiagonalStripesOverlay()
}
