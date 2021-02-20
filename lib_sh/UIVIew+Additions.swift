// swiftlint:disable literal_expression_end_indentation
//
//  UIView+Extensions.swift
//  Concierge
//
//  Created by Adam Mork on 9/11/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import UIKit

public extension UIView {
    func layoutSame(as container: UIView) {
        [
            self.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            self.widthAnchor.constraint(equalTo: container.widthAnchor),
            self.heightAnchor.constraint(equalTo: container.heightAnchor)
            ].activateAll()
    }

    func layoutSame(as container: UILayoutGuide) {
        [
            self.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            self.widthAnchor.constraint(equalTo: container.widthAnchor),
            self.heightAnchor.constraint(equalTo: container.heightAnchor)
            ].activateAll()
    }

    func fill(inside container: UIView) {
        [
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            self.topAnchor.constraint(equalTo: container.topAnchor),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ].activateAll()
    }

    func fill(inside container: UILayoutGuide) {
        [
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            self.topAnchor.constraint(equalTo: container.topAnchor),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ].activateAll()
    }

    func fill(inside container: UIView, padding: CGFloat) {
        [
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padding),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -1.0 * padding),
            self.topAnchor.constraint(equalTo: container.topAnchor, constant: padding),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -1 * padding)
            ].activateAll()
    }

    func fill(inside container: UILayoutGuide, padding: CGFloat) {
        [
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padding),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -1.0 * padding),
            self.topAnchor.constraint(equalTo: container.topAnchor, constant: padding),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -1 * padding)
            ].activateAll()
    }

    func fill(inside container: UIView, verticalPadding: CGFloat = 0, horizontalPadding: CGFloat = 0) {
        [
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: horizontalPadding),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -1.0 * horizontalPadding),
            self.topAnchor.constraint(equalTo: container.topAnchor, constant: verticalPadding),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -1 * verticalPadding)
            ].activateAll()
    }

    func fill(inside container: UILayoutGuide, verticalPadding: CGFloat = 0, horizontalPadding: CGFloat = 0) {
        [
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: horizontalPadding),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -1.0 * horizontalPadding),
            self.topAnchor.constraint(equalTo: container.topAnchor, constant: verticalPadding),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -1 * verticalPadding)
            ].activateAll()
    }

    func centered(inside container: UIView) {
        /*
         guard container.intrinsicContentSize != CGSize(width: -1.0, height: -1.0) else {
         fatalError("Cannot center view with no intrinsic content size. use: UIView.center(inside:UIView, width:CGFloat, height:CGFloat) instead")
         }
         */
        [
            self.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ].activateAll()
    }
    func centered(inside container: UIView, width: CGFloat, height: CGFloat) {
        [
            self.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            self.widthAnchor.constraint(equalTo: container.widthAnchor, constant: width),
            self.heightAnchor.constraint(equalTo: container.heightAnchor, constant: height)
            ].activateAll()
    }
    func equalWidthsCenter(inside container: UIView) {
        [
            self.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            self.widthAnchor.constraint(equalTo: container.widthAnchor)
            ].activateAll()
    }
    func horizontallyCentered(inside container: UIView, minimumPadding: CGFloat) {
        [
            self.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            self.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: minimumPadding),
            self.trailingAnchor.constraint(greaterThanOrEqualTo: container.trailingAnchor, constant: -1.0 * minimumPadding)
            ].activateAll()
    }
}

public extension Collection where Iterator.Element == NSLayoutConstraint {
    func activateAll() {
        NSLayoutConstraint.activate(Array(self))
    }
}

public extension NSLayoutConstraint {
    func activate() {
        NSLayoutConstraint.activate([self])
    }
}

public extension UIView {
    func verticallyCenterInside(_ parent: UIView) {
        let ourFrame = self.frame
        let xValue: CGFloat = ourFrame.origin.x
        let yValue: CGFloat = parent.frame.size.height / 2 - (ourFrame.size.height / 2)
        let width = ourFrame.size.width
        let height = ourFrame.size.height
        self.frame = CGRect(x: xValue, y: yValue, width: width, height: height)
    }
}
