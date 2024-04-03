import SwiftUI

class MainViewModel: ObservableObject {
    @Published var numerator = "54"
    @Published var denominator = "12"
    @Published var calculations: [Calculation] = []
    @Published var fractionDecompositionLatex: String = ""
    @Published var openFractionDecomposition: Bool = false

    var haveCalculations: Bool {
        numerator != "" && denominator != ""
    }

    func calc() {
        guard
            var numerator = Int(numerator),
            var denominator = Int(denominator)
        else {
            return
        }

        var result: [Calculation] = []

        while (denominator != 0) {
            let remainder = numerator % denominator

            result.append(Calculation(
                numerator: numerator,
                denominator: denominator,
                remainder: remainder,
                result: (numerator - remainder) / denominator
            ))

            numerator = denominator
            denominator = remainder
        }

        var fractionDecompositionLatex = ""

        if result.count < 1 {
            fractionDecompositionLatex = ""
        } else {
            for i in 0..<result.count - 1 {
                fractionDecompositionLatex += "\(result[i].result) + \\dfrac{1}{"
            }

            fractionDecompositionLatex += result[result.count-1].result.description

            for _ in 0..<result.count - 1 {
                fractionDecompositionLatex += "}"
            }
        }

        self.fractionDecompositionLatex = fractionDecompositionLatex
        self.calculations = result
    }
}
