//
//  XMarkButton.swift
//  CryptoX
//
//  Created by pritam on 2024-09-26.
//

import SwiftUI

struct XMarkButton: View {
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }
}

#Preview {
    XMarkButton()
}
