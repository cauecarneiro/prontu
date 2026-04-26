import SwiftUI

struct TopBarSheet: View {

    let title: String
    let dismissAction: () -> Void
    static let topBarHeight: CGFloat = 141
    static let topBarHorizontalPadding: CGFloat = 24

    var body: some View {
        HStack {

            iconButton(systemName: "xmark") {
                dismissAction()
            }

            Text(title)
                .font(.system(
                    size: GlobalConfiguration.Layout.sectionHeaderFontSize + 2,
                    weight: .bold
                ))
                .frame(maxWidth: .infinity)

            Color.clear
                .frame(
                    width: GlobalConfiguration.Layout.iconButtonSize,
                    height: GlobalConfiguration.Layout.iconButtonSize
                )
        }
        .padding(
            .horizontal,
            Self.topBarHorizontalPadding
        )
        .frame(
            height: Self.topBarHeight
        )
    }
}
