import SwiftUI

internal struct AnyEquatable: Equatable {
    
    let value: Any
    private let isEqualTo: (Any) -> Bool
    
    init<E: Equatable>(_ value: E) {
        self.value = value
        self.isEqualTo = { $0 as? E == value }
    }
    
    static func == (lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
        return lhs.isEqualTo(rhs.value)
    }
}

internal struct ValueActionKey: PreferenceKey {
  
    static var defaultValue: AnyEquatable? = nil

    static func reduce(value: inout AnyEquatable?, nextValue: () -> AnyEquatable?) {
        value = nextValue()
    }
}

internal struct ValueActionModifier<Value: Equatable>: ViewModifier {
    
    let value: Value
    let action: (Value) -> Void
    
    func body(content: Content) -> some View {
        content
            .preference(key: ValueActionKey.self, value: AnyEquatable(value))
            .onPreferenceChange(ValueActionKey.self) { anyEquatable in
                guard let value = anyEquatable?.value as? Value else { return }
                action(value)
            }
    }
}

public extension View {
    
    /// Adds a modifier for this view that fires an action when a specific
    /// value changes.
    ///
    /// You can use `onChange` to trigger a side effect as the result of a
    /// value changing, such as an `Environment` key or a `Binding`.
    ///
    /// `onChange` is called on the main thread. Avoid performing long-running
    /// tasks on the main thread. If you need to perform a long-running task in
    /// response to `value` changing, you should dispatch to a background queue.
    ///
    /// The new value is passed into the closure. The previous value may be
    /// captured by the closure to compare it to the new value. For example, in
    /// the following code example, `PlayerView` passes both the old and new
    /// values to the model.
    ///
    ///     struct PlayerView : View {
    ///         var episode: Episode
    ///         @State private var playState: PlayState = .paused
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Text(episode.title)
    ///                 Text(episode.showTitle)
    ///                 PlayButton(playState: $playState)
    ///             }
    ///             .onChange(of: playState) { [playState] newState in
    ///                 model.playStateDidChange(from: playState, to: newState)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - value: The value to check against when determining whether
    ///     to run the closure.
    ///   - action: A closure to run when the value changes.
    ///   - newValue: The new value that failed the comparison check.
    ///
    /// - Returns: A view that fires an action when the specified value changes.
    @available(iOS, introduced: 13.0, obsoleted: 14.0)
    @available(macOS, introduced: 10.15, obsoleted: 11.0)
    @available(tvOS, introduced: 13.0, obsoleted: 14.0)
    @available(watchOS, introduced: 6.0, obsoleted: 7.0)
    func onChange<Value: Equatable>(of value: Value, perform action: @escaping (Value) -> Void) -> some View {
        self.modifier(ValueActionModifier(value: value, action: action))
    }
}
