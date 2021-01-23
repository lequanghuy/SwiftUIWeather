//
//  BlurView.swift
//  SwiftUIWeather
//
//  Created by Lê Huy on 20/01/2021.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    
    var style: UIBlurEffect.Style
    
    typealias UIViewType = UIView
    
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<BlurView>) {
        
    }
}

struct BackgroundBlurView: UIViewRepresentable {
    
    var style: UIBlurEffect.Style
    
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        let result = UIView()
        DispatchQueue.main.async {
            let view = result.superview
            view?.backgroundColor = .clear
            view?.superview?.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: style)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.translatesAutoresizingMaskIntoConstraints = false
            view!.insertSubview(blurView, at: 0)
            NSLayoutConstraint.activate([
                blurView.widthAnchor.constraint(equalTo: view!.widthAnchor),
                blurView.heightAnchor.constraint(equalTo: view!.heightAnchor)
            ])
        }
        return result
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
