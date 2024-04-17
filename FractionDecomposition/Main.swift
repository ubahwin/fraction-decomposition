import SwiftUI
import LaTeXSwiftUI

struct Main: View {
    @StateObject private var mainVM = MainViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Вдовин Иван, ИЗ-32").bold()
                        .padding(.top)
                    LaTeX("Представить рациональное число $a/b$ непрерывной дробью, вычислить подходящие дроби.")
                        .padding()
                    TextField("", text: $mainVM.numerator)
                        .frame(width: 200)
                        .font(.system(size: 50))

                    TextField("", text: $mainVM.denominator)
                        .font(.system(size: 50))
                        .frame(width: 200)

                    if mainVM.haveCalculations {
                        ZStack {
                            Rectangle().fill(.clear)
                                .frame(height: 400)

                            VStack {
                                Text("Разложение:").padding()

                                ForEach(Array(mainVM.calculations.enumerated()), id: \.element) { index, element in
                                    LaTeX("$\(element.numerator) = \(element.denominator) \\cdot  \(element.result) + \(element.remainder) \\Rightarrow q_{\(index + 1)} = \(element.result), r_{\(index + 2)} = \(element.remainder)$")
                                }

                                if mainVM.openFractionDecomposition {
                                    LaTeX("$\(mainVM.fractionDecompositionLatex)$")
                                        .padding()
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .font(.title)
            .navigationTitle("Представление рациональных чисел непрерывными дробями")
        }
        .onKeyPress(keys: [.space]) { press in
            Task {
                mainVM.calc()
                mainVM.openFractionDecomposition = true
            }
            return .handled
        }
        .onChange(of: [mainVM.numerator, mainVM.denominator]) { _, _ in
            mainVM.openFractionDecomposition = false
            mainVM.calc()
        }
        .onAppear {
            mainVM.calc()
        }
    }
}

#Preview {
    Main()
}
