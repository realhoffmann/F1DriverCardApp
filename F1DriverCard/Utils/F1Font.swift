import SwiftUI

struct F1Font: ViewModifier {
    enum Style { case regular, bold, wide }
    
    var style: Style
    var size: CGFloat
    
    func body(content: Content) -> some View {
        switch style {
        case .regular:
            return content.font(.f1Regular(size))
        case .bold:
            return content.font(.f1Bold(size))
        case .wide:
            return content.font(.f1Wide(size))
        }
    }
}

extension Font {
    static func f1Regular(_ size: CGFloat) -> Font {
        .custom("Formula1-Display-Regular", size: size)
    }
    
    static func f1Bold(_ size: CGFloat) -> Font {
        .custom("Formula1-Display-Bold", size: size)
    }
    
    static func f1Wide(_ size: CGFloat) -> Font {
        .custom("Formula1-Display-Wide", size: size)
    }
}

extension View {
    func f1Font(_ style: F1Font.Style, size: CGFloat) -> some View {
        self.modifier(F1Font(style: style, size: size))
    }
}
