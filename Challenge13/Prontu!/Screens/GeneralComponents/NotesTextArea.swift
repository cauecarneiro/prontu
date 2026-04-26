//
//  NotesSection.swift
//  Challenge13
//
//  Created by Linda Marie Ribeiro Alves Correa dos Santos on 23/04/26.
//

import SwiftUI

 let textAreaHorizontalPadding: CGFloat = 18
 let textAreaVerticalPadding: CGFloat = 16
 let textAreaIconSpacing: CGFloat = 4
 let textAreaHeight: CGFloat = 173


struct NotesTextArea<Field: Hashable>: View {

    @Binding var text: String

    let placeholder: String
    let icon: String

    @FocusState.Binding var focusedField: Field?
    let field: Field

    var body: some View {

        ZStack(alignment: .topLeading) {

            TextEditor(text: $text)
                .scrollContentBackground(.hidden)
                .font(.system(
                    size: GlobalConfiguration.Layout.sectionHeaderFontSize
                ))
                .focused($focusedField, equals: field)
                .padding(.horizontal, textAreaHorizontalPadding
                )
                .padding(.vertical, textAreaVerticalPadding
                )

            if focusedField != field && text.isEmpty {

                HStack(
                    alignment: .top,
                    spacing: textAreaIconSpacing
                ) {

                    Image(systemName: icon)
                        .font(.system(
                            size: GlobalConfiguration.Layout.sectionHeaderFontSize,
                            weight: .bold
                        ))
                        .foregroundStyle(.primary)

                    Text(placeholder)
                        .font(.system(
                            size: GlobalConfiguration.Layout.sectionHeaderFontSize
                        ))
                        .foregroundStyle(.placeholder)
                }
                .padding(
                    .horizontal, textAreaHorizontalPadding
                )
                .padding(
                    .vertical,
                    textAreaVerticalPadding
                )
                .allowsHitTesting(false)
            }
        }
        .frame(height: textAreaHeight)
        .background(.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: GlobalConfiguration.normalCornerRadius
            )
        )
        .onTapGesture {
            focusedField = field
        }
    }
}
