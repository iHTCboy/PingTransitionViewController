//
//  ViewController.swift
//  PingTransition-Swift
//
//  Created by HTC on 2017/5/20.
//  Copyright © 2017年 iHTCboy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.gray
        view.addSubview(button);
    }
    
    var button: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: 20, y: 100, width: 48, height: 48))
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(clickedButton), for: .touchUpInside)
        return button;
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func clickedButton() {
        // Target View
        self.pingView = self.button;
        self.navigationController?.pushViewController(SecondViewController(), animated: true)
    }


}

extension ViewController: UINavigationControllerDelegate
{
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if (operation == .push) {
            return PingTransition.init(operation: operation)
        }else{
            return nil
        }
    }
}

