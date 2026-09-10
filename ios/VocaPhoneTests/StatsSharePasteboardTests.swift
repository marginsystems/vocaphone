import Testing
import UIKit

/// X pastes through `UIPasteboard.string` and `.image`, which read only the
/// first pasteboard item, so this checks what a Paste into X receives.
@MainActor
struct StatsSharePasteboardTests {
    @Test func xPayloadCopiesTheCardBeforeItsText() {
        let card = UIGraphicsImageRenderer(size: CGSize(width: 4, height: 4)).image { context in
            UIColor.green.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 4, height: 4))
        }
        let originalItems = UIPasteboard.general.items
        defer { UIPasteboard.general.items = originalItems }

        let payload = StatsShareExporter.copyXPayload(image: card, message: "hello")
        #expect(UIPasteboard.general.image != nil)
        #expect(payload.cardCopied == true)
        #expect(payload.textCopied)

        let withoutCard = StatsShareExporter.copyXPayload(image: nil, message: "hello")
        #expect(withoutCard.cardCopied == false)
    }
}
