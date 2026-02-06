//
//  UIButton+.swift
//  SMASHING
//
//  Created by 이승준 on 2/6/26.
//

import Combine
import UIKit

extension UIControl {

    func controlEventPublisher(for event: UIControl.Event) -> AnyPublisher<Void, Never> {
        let subject = PassthroughSubject<Void, Never>()
        let handler = EventHandler(subject: subject)
        addTarget(handler, action: #selector(EventHandler.invoke), for: event)

        var handlers = (objc_getAssociatedObject(self, &AssociatedKeys.eventHandlers) as? [EventHandler]) ?? []
        handlers.append(handler)
        objc_setAssociatedObject(self, &AssociatedKeys.eventHandlers, handlers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        return subject.eraseToAnyPublisher()
    }

}

extension UIButton {

    func tapPublisher() -> AnyPublisher<Void, Never> {
        controlEventPublisher(for: .touchUpInside)
    }

}

private enum AssociatedKeys {
    static var eventHandlers: UInt8 = 0
}

private final class EventHandler: NSObject {

    let subject: PassthroughSubject<Void, Never>

    init(subject: PassthroughSubject<Void, Never>) {
        self.subject = subject
    }

    @objc func invoke() {
        subject.send()
    }

}
