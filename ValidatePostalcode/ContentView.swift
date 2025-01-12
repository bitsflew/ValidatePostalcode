//
//  ContentView.swift
//  ValidatePostalcode
//
//  Created by Henk on 05/12/2024.
//

import SwiftUI



extension String {
    enum DutchPostalcodeFormat {
        case loose
        case strict
        
        var pattern: Regex<(Substring, Substring, Substring)> {
            return switch self {
            case .loose:   /^\s*([1-9]\d{3})\s*([A-Z,a-z]{2})\s*$/
            case .strict:   /^([1-9]\d{3})([A-Z,a-z]{2})$/
            }
        }
    }
    
    func dutchPostalcode(format: DutchPostalcodeFormat) -> String? {
        let  match: Regex<(Substring, Substring, Substring)>.Match? = self.firstMatch(of: format.pattern)
        return if let match {
            "\(match.1)\(match.2.uppercased())"
        } else {
            nil
        }
    }
}

final class PostalcodeRepo: ObservableObject {
    init() {
        postalCode = UserDefaults.standard.string(forKey: "postalcode")
    }
    @Published var postalCode: String? {
        didSet {
            UserDefaults.standard.set(postalCode, forKey: "postalcode")
        }
    }
    
}

struct ContentView: View {
    @AppStorage("postalcode") var postalCode: String?
   // @State var postalCode: String?
    @State var inputText: String = ""

    func attempSate() {
        if let postalCode {
            inputText = postalCode
            print("Success: \(postalCode)")
        } else {
            print("Failure")
        }
    }
    
  
    
    var body: some View {
        VStack {
            HStack {
                Text(postalCode ?? "")
                TextField("Enter your text", text: $inputText)
                    .onChange(of: inputText) { newValue in
                        inputText = newValue.filter { $0.isLetter || $0.isNumber }
                            .uppercased()
                        
                        postalCode = inputText.dutchPostalcode(format: .loose)
                    }
                    .onAppear {
                        inputText =  postalCode?.dutchPostalcode(format: .loose) ?? ""
                    }
                    .onSubmit {
                        attempSate()
                    }

                Button(action: {
                    attempSate()
                }) {
                    Text("Bewaar")
                }
                .disabled(postalCode == nil)
            }
           
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
