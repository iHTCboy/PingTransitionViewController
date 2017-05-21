//
//  SecondViewController.swift
//  PingTransition-Swift
//
//  Created by HTC on 2017/5/20.
//  Copyright © 2017年 iHTCboy. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let edgeGes = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(edgePan(recognizer:)))
        edgeGes.edges = .left;
        view.addGestureRecognizer(edgeGes)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.popViewController(animated: true)
    }


}


extension SecondViewController: UINavigationControllerDelegate
{
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if (operation == .pop) {
            return PingTransition.init(operation: operation)
        }else{
            return nil;
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return popTransition
    }
    
    func edgePan(recognizer: UIPanGestureRecognizer) {
        
        var per = recognizer.translation(in: self.view).x / self.view.bounds.width
        
        per = min(1.0, max(0.0, per))
        
        if (recognizer.state == .began) {
            popTransition = UIPercentDrivenInteractiveTransition.init()
            self.navigationController?.popViewController(animated: true)
        }else if (recognizer.state == .changed){
            popTransition?.update(per)
        }else if (recognizer.state == .ended || recognizer.state == .cancelled){
            if (per > 0.3) {
                popTransition?.finish()
            }else{
                popTransition?.cancel()
            }
            popTransition = nil;
        }
    }
}
