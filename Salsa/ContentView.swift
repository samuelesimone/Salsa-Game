import SwiftUI

struct ContentView: View {
    
    let iconOptions = ["", "sun.max.fill", "moon"]
    @State private var iconIndices: [Int] = Array(repeating: 0, count: 36)
    let gridSize = 6
    @State private var matchedIndices: Set<Int> = []
    
    @State private var timer: Timer?
    @State private var timeElapsed: Int = 0
    @State private var isTimerPaused = false
    @State private var gameWon: Bool = false
    @State private var diagonalVisibility = true
   
    
    var body: some View {
        VStack {
            HStack {
                if !gameWon {
                    Text("Tempo: \(timeElapsed)s")
                        .font(.title)
                        .padding()
                }else {
                    Text("Hai vinto in \(timeElapsed)s!")
                        .font(.title)
                        .padding()
                }
                if isTimerPaused {
                    Text("Pausa")
                    .font(.title)
                    .padding()
                }
                
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: gridSize)) {
                ForEach(0..<36, id: \.self) { index in
                    Button(action: {
                        if !gameWon && !isTimerPaused{
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
                        
                            if isRowAndColumnInvalid(for: index) {
                                   
                                if diagonalVisibility && iconOptions[iconIndices[index]] != "" {
                                    DiagonalStripesOverlay()
                                        .opacity(0.3)
                                }
                                    
                                }
                                
                                
                                else if matchedIndices.contains(index) {
                                  
                                    if diagonalVisibility && iconOptions[iconIndices[index]] != "" {
                                        DiagonalStripesOverlay()
                                            .opacity(0.3)
                                    }
                                }

                            if iconOptions[iconIndices[index]] != "" {
                                Image(systemName: iconOptions[iconIndices[index]])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .symbolRenderingMode(.monochrome)
                                    .foregroundColor(.primary)
                               
                            }
                            

                        }
                    }
                }
            }
            .padding()
            Button("Restart", systemImage: "restart", action: RestartGame)
            Button("Pause", systemImage: "pause", action: PauseGame)
            
                
        }
        .onAppear {
            startTimer()
        }
    }
    func PauseGame() {
        isTimerPaused = !isTimerPaused
    }
    func RestartGame() {
        timeElapsed = 0
        gameWon = false
        ResetGrid()
            
        
    }
    func ResetGrid() {
        iconIndices = Array(repeating: 0, count: 36)
    }
    
    // MARK: - Helpers per Righe e Colonne
    func iconsInRow(_ row: Int) -> [Int] {
        Array(iconIndices[(row * gridSize)..<((row + 1) * gridSize)])
    }

    func iconsInColumn(_ col: Int) -> [Int] {
        (0..<gridSize).map { row in
            iconIndices[row * gridSize + col]
        }
    }

    // MARK: - Validazione di una riga o colonna
    func isValidIcons(_ icons: [Int]) -> Bool {
        let nonEmptyIcons = icons.filter { $0 != 0 }
        guard nonEmptyIcons.count == gridSize else { return false } // devono essere tutte riempite

        let counts = nonEmptyIcons.reduce(into: [Int: Int]()) { $0[$1, default: 0] += 1 }
        return counts.count == 2 && counts.values.allSatisfy { $0 == 3 }
    }

    // MARK: - Validazione specifica per un indice
    func isValidAtIndex(_ index: Int) -> Bool {
        let row = index / gridSize
        let col = index % gridSize
        return isValidIcons(iconsInRow(row)) || isValidIcons(iconsInColumn(col))
    }
    
    func isRowAndColumnInvalid(for index: Int) -> Bool {
        let row = index / gridSize
        let col = index % gridSize

        let rowIcons = iconsInRow(row)
        let colIcons = iconsInColumn(col)

        let isRowFull = !rowIcons.contains(0)
        let isColFull = !colIcons.contains(0)

        let isRowInvalid = isRowFull && !isValidIcons(rowIcons)
        let isColInvalid = isColFull && !isValidIcons(colIcons)

        return isRowInvalid || isColInvalid
    }


    // MARK: - Validazione completa della griglia
    func checkAllValid() -> Bool {
        for i in 0..<gridSize {
            if !isValidIcons(iconsInRow(i)) || !isValidIcons(iconsInColumn(i)) {
                return false
            }
        }
        return true
    }

    // MARK: - Matching di 3 simboli consecutivi
    func checkMatches() {
        var newMatched: Set<Int> = []

        // Controlla righe
        for row in 0..<gridSize {
            for col in 0..<(gridSize - 2) {
                let i1 = row * gridSize + col
                let i2 = i1 + 1
                let i3 = i2 + 1

                if isMatch(i1, i2, i3) {
                    newMatched.formUnion([i1, i2, i3])
                }
            }
        }

        // Controlla colonne
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

    // Confronta tre celle
    func isMatch(_ i1: Int, _ i2: Int, _ i3: Int) -> Bool {
        let value = iconIndices[i1]
        return value != 0 && iconIndices[i2] == value && iconIndices[i3] == value
    }

    // MARK: - Cronometro
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if !gameWon && !isTimerPaused {
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
