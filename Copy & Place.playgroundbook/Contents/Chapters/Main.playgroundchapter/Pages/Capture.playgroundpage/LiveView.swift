import UIKit
import PlaygroundSupport

class PlaygroundView: UIView, PlaygroundLiveViewSafeAreaContainer {}

class OrientationViewController: UIViewController {
    var portrait = UIButton()
    var portraitUpsideDown = UIButton()
    var landscapeLeft = UIButton()
    var landscapeRight = UIButton()
    let ipad = UIImage(named: "ipad")!.cgImage!
    let ipadSelected = UIImage(named: "ipad-selected")!.cgImage!
    
    override func loadView() {
        view = PlaygroundView()
        view.backgroundColor = .white
        /*portrait.showsTouchWhenHighlighted = true
        portraitUpsideDown.showsTouchWhenHighlighted = true
        landscapeLeft.showsTouchWhenHighlighted = true
        landscapeRight.showsTouchWhenHighlighted = true*/
        untint()
        portrait.addTarget(nil, action: #selector(self.portraitF), for: .touchUpInside)
        portraitUpsideDown.addTarget(nil, action: #selector(self.portraitUpsideDownF), for: .touchUpInside)
        landscapeLeft.addTarget(nil, action: #selector(self.landscapeLeftF), for: .touchUpInside)
        landscapeRight.addTarget(nil, action: #selector(self.landscapeRightF), for: .touchUpInside)
        view.addSubview(portrait)
        view.addSubview(portraitUpsideDown)
        view.addSubview(landscapeLeft)
        view.addSubview(landscapeRight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*NSLayoutConstraint.activate([
            portrait.leadingAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.leadingAnchor),
            portraitUpsideDown.leadingAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.leadingAnchor),
            landscapeLeft.leadingAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.leadingAnchor),
            landscapeRight.leadingAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.leadingAnchor),
            portrait.trailingAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.trailingAnchor),
            portraitUpsideDown.trailingAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.trailingAnchor),
            landscapeLeft.trailingAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.trailingAnchor),
            landscapeRight.trailingAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.trailingAnchor),
            portrait.topAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.topAnchor),
            portraitUpsideDown.topAnchor.constraint(equalTo: portrait.bottomAnchor),
            landscapeLeft.topAnchor.constraint(equalTo: portraitUpsideDown.bottomAnchor),
            landscapeRight.topAnchor.constraint(equalTo: landscapeLeft.bottomAnchor),
            landscapeRight.bottomAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.bottomAnchor),
            portrait.heightAnchor.constraint(equalTo: portraitUpsideDown.heightAnchor),
            portraitUpsideDown.heightAnchor.constraint(equalTo: landscapeLeft.heightAnchor),
            landscapeLeft.heightAnchor.constraint(equalTo: landscapeRight.heightAnchor),
            landscapeRight.heightAnchor.constraint(equalTo: portrait.heightAnchor),
            portrait.widthAnchor.constraint(equalTo: portraitUpsideDown.widthAnchor),
            portraitUpsideDown.widthAnchor.constraint(equalTo: landscapeLeft.widthAnchor),
            landscapeLeft.widthAnchor.constraint(equalTo: landscapeRight.widthAnchor),
            landscapeRight.widthAnchor.constraint(equalTo: portrait.widthAnchor)
            ])*/
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        portrait.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 4)
        portraitUpsideDown.frame = CGRect(x: 0, y: view.frame.height / 4, width: view.frame.width, height: view.frame.height / 4)
        landscapeLeft.frame = CGRect(x: 0, y: (view.frame.height / 4) * 2, width: view.frame.width, height: view.frame.height / 4)
        landscapeRight.frame = CGRect(x: 0, y: (view.frame.height / 4) * 3, width: view.frame.width, height: view.frame.height / 4)
        NSLayoutConstraint.activate([
            portrait.widthAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.widthAnchor),
            portraitUpsideDown.widthAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.widthAnchor),
            landscapeLeft.widthAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.widthAnchor),
            landscapeRight.widthAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.widthAnchor),
            portrait.leadingAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.leadingAnchor),
            portraitUpsideDown.leadingAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.leadingAnchor),
            landscapeLeft.leadingAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.leadingAnchor),
            landscapeRight.leadingAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.leadingAnchor)
            ])
    }
    
    func untint() {
        portrait.setImage(UIImage(cgImage: ipad), for: .normal)
        portraitUpsideDown.setImage(UIImage(cgImage: ipad, scale: 1.0, orientation: .down), for: .normal)
        landscapeLeft.setImage(UIImage(cgImage: ipad, scale: 1.0, orientation: .left), for: .normal)
        landscapeRight.setImage(UIImage(cgImage: ipad, scale: 1.0, orientation: .right), for: .normal)
    }
    
    @objc func portraitF() {
        PlaygroundKeyValueStore.current["orientation"] = .integer(1)
        untint()
        portrait.setImage(UIImage(cgImage: ipadSelected), for: .normal)
    }
    
    @objc func portraitUpsideDownF() {
        PlaygroundKeyValueStore.current["orientation"] = .integer(2)
        untint()
        portraitUpsideDown.setImage(UIImage(cgImage: ipadSelected, scale: 1.0, orientation: .down), for: .normal)
    }
    
    @objc func landscapeLeftF() {
        PlaygroundKeyValueStore.current["orientation"] = .integer(3)
        untint()
        landscapeLeft.setImage(UIImage(cgImage: ipadSelected, scale: 1.0, orientation: .left), for: .normal)
    }
    
    @objc func landscapeRightF() {
        PlaygroundKeyValueStore.current["orientation"] = .integer(4)
        untint()
        landscapeRight.setImage(UIImage(cgImage: ipadSelected, scale: 1.0, orientation: .right), for: .normal)
    }
}

var vc = OrientationViewController()
PlaygroundPage.current.liveView = vc
