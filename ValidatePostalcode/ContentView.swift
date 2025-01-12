//
//  ContentView.swift
//  ValidatePostalcode
//
//  Created by Henk on 05/12/2024.
//

import SwiftUI

struct DutchPostalcode {
    let value: String
    init?(value: String) {
        guard let value = value.dutchPostalcode
        else { return nil }
        self.value = value
    }
}

extension String {
    var dutchPostalcode: String? {
        let pattern = /^\s*([1-9]\d{3})\s*([A-Z,a-z]{2})\s*$/

        return if let match = firstMatch(of: pattern) {
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
                        
                        postalCode = inputText.dutchPostalcode
                    }
                    .onAppear {
                        inputText =  postalCode?.dutchPostalcode ?? ""
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
