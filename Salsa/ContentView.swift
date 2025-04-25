import SwiftUI

struct ContentView: View {
    
    let iconOptions = ["", "sun.max.fill", "moon"]
    @State private var iconIndices: [Int] = Array(repeating: 0, count: 36)
    let gridSize = 6
    @State private var matchedIndices: Set<Int> = []
    
    @State private var timer: Timer?
    @State private var timeElapsed: Int = 0
    @State private var gameWon: Bool = false
    
    var body: some View {
        VStack {
            // Cronometro
            HStack {
                Text(!gameWon ? "Tempo: \(timeElapsed)s" : "Hai vinto in \(timeElapsed)s!")
                    .font(.title)
                    .padding()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: gridSize)) {
                ForEach(0..<36, id: \.self) { index in
                    Button(action: {
                        if !gameWon {
                            // Update the icon cell
                            iconIndices[index] = (iconIndices[index] + 1) % iconOptions.count
                            
                     
                            checkMatches()
                            
                          
                            if checkAllValid() && !gameWon {
                                print("Hai vinto!")
                                stopTimer()
                                gameWon = true
                                
                            } else {
                                print("Non ancora.")
                            }
                        }
                       
                    }) {
                        ZStack {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(width: 60, height: 60)
                                .border(Color.gray, width: 1)

                            if iconOptions[iconIndices[index]] != "" {
                                Image(systemName: iconOptions[iconIndices[index]])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(matchedIndices.contains(index) ? Color.red : Color.primary)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            startTimer()
        }
    }

    // MARK: - Funzione di controllo della validità
    func isValidRowOrColumn(index: Int) -> Bool {
        // Calcola la riga e la colonna
        let row = index / gridSize
        let col = index % gridSize

        // Verifica la riga
        let rowIcons = Array(iconIndices[(row * gridSize)..<((row + 1) * gridSize)])
        if isValidRowOrColumn(icons: rowIcons) {
            return true
        }

        // Verifica la colonna
        var colIcons = [Int]()
        for r in 0..<gridSize {
            colIcons.append(iconIndices[r * gridSize + col])
        }
        return isValidRowOrColumn(icons: colIcons)
    }

    // MARK: - Funzione di validità per una riga o colonna
    func isValidRowOrColumn(icons: [Int]) -> Bool {
        let uniqueIcons = Set(icons)
        if uniqueIcons.count == 2 { // Devono esserci solo 2 tipi di icone
            let counts = icons.reduce(into: [Int: Int]()) { $0[$1, default: 0] += 1 }
            return counts.values.contains(3) && counts.values.contains(3)
        }
        return false
    }

    // MARK: - Check per tutte le righe e colonne
    func checkAllValid() -> Bool {
        // Verifica tutte le righe
        for row in 0..<gridSize {
            let rowIcons = Array(iconIndices[(row * gridSize)..<((row + 1) * gridSize)])
            if !isValidRowOrColumn(icons: rowIcons) {
                return false  // Se una riga non è valida, ritorna false
            }
        }

        // Verifica tutte le colonne
        for col in 0..<gridSize {
            var colIcons = [Int]()
            for row in 0..<gridSize {
                colIcons.append(iconIndices[row * gridSize + col])
            }
            if !isValidRowOrColumn(icons: colIcons) {
                return false  // Se una colonna non è valida, ritorna false
            }
        }

        return true  // Tutte le righe e colonne sono valide
    }

    // MARK: - Check per 3 in a row or column
    func checkMatches() {
        var newMatched: Set<Int> = []

        // Check righe
        for row in 0..<gridSize {
            for col in 0..<(gridSize - 2) {
                let i1 = row * gridSize + col
                let i2 = i1 + 1
                let i3 = i1 + 2

                if isMatch(i1, i2, i3) {
                    newMatched.formUnion([i1, i2, i3])
                }
            }
        }

        // Check colonne
        for col in 0..<gridSize {
            for row in 0..<(gridSize - 2) {
                let i1 = row * gridSize + col
                let i2 = i1 + gridSize
                let i3 = i2 + gridSize

                if isMatch(i1, i2, i3) {
                    newMatched.formUnion([i1, i2, i3])
                }
            }
        }

        matchedIndices = newMatched
    }

    func isMatch(_ i1: Int, _ i2: Int, _ i3: Int) -> Bool {
        let value = iconIndices[i1]
        return value != 0 && iconIndices[i2] == value && iconIndices[i3] == value
    }

    // MARK: - Cronometro
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if !gameWon {
                timeElapsed += 1
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
    }
}

#Preview {
    ContentView()
}
