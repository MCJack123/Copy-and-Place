/*:
 Now that the iPad has identified the object, you can place an image of that type of object in the real world using AR. Press "Run My Code" to start the AR experience.
 
 Try walking around the world and tap on places on the camera to place the object. You can place them anywhere, but they will automatically stick to any ground you place them on.
 
 Next, try tapping on one of the objects you already placed. It will start to shake!

 *If you have experience coding, you can add your own animation to play when you tap on the screen. The code below will give you more information.*
 
 ---
 
 ![Demo AR](demo-AR.mp4)
 *The video above shows you how to use the AR functionality.*
 */
//#-hidden-code
import UIKit
import ARKit
import SpriteKit
import PlaygroundSupport

class PlaygroundView: UIView, PlaygroundLiveViewSafeAreaContainer {}
var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
var objectName: String?
//#-end-hidden-code
var onTapFound = [(SKSpriteNode)->Void]()
var onTapUnfound = [(ARSKView, ARHitTestResult)->Void]()

//#-hidden-code

class NotificationView: UIView {
    //var text: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
        self.isOpaque = false
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.clear(rect)
        context?.beginPath()
        context?.clear(rect)
        context?.setFillColor(UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 0.75).cgColor)
        context?.move(to: CGPoint(x: rect.height / 4, y: 0))
        context?.addLine(to: CGPoint(x: rect.width - (rect.height / 4), y: 0))
        context?.addQuadCurve(to: CGPoint(x: rect.width, y: rect.height / 4), control: CGPoint(x: rect.width, y: 0))
        context?.addLine(to: CGPoint(x: rect.width, y: (rect.height / 4) * 3))
        context?.addQuadCurve(to: CGPoint(x: rect.width - (rect.height / 4), y: rect.height), control: CGPoint(x: rect.width, y: rect.height))
        context?.addLine(to: CGPoint(x: rect.height / 4, y: rect.height))
        context?.addQuadCurve(to: CGPoint(x: 0, y: (rect.height / 4) * 3), control: CGPoint(x: 0, y: rect.height))
        context?.addLine(to: CGPoint(x: 0, y: rect.height / 4))
        context?.addQuadCurve(to: CGPoint(x: rect.height / 4, y: 0), control: CGPoint(x: 0, y: 0))
        context?.fillPath()
        //context?.closePath()
    }
}

class ARViewController: UIViewController, ARSKViewDelegate {
    
    var arView = ARSKView()
    var initialCenter = CGPoint()
    var dragAnchor: ARAnchor?
    var notification: NotificationView?
    var notifyTimer = Timer(timeInterval: 0, repeats: false, block: {(Timer) in})
    
    override func loadView() {
        view = PlaygroundView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        arView.delegate = self
        
        // Show statistics such as fps and node count
        arView.showsFPS = false
        arView.showsNodeCount = false
        
        // Load the SKScene from 'Scene.sks'
        if let scene = SKScene(fileNamed: "Scene") {
            arView.presentScene(scene)
        }
        
        arView.clipsToBounds = true
        arView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(arView)
        NSLayoutConstraint.activate([
            arView.leadingAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.leadingAnchor),
            arView.trailingAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.trailingAnchor),
            arView.topAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.topAnchor),
            arView.bottomAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.bottomAnchor)
            ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        arView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        arView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPos = touches.first!.location(in: nil)
        let hits = arView.scene!.nodes(at: arView.convert(touchPos, to: arView.scene!))
        if hits.count > 0 {
            onTapFound[Int(arc4random_uniform(UInt32(onTapFound.count)))](hits[0] as! SKSpriteNode)
        } else {
            let hits2 = arView.hitTest(touchPos, types: .featurePoint)
            if hits2.count > 0 {
                onTapUnfound[Int(arc4random_uniform(UInt32(onTapUnfound.count)))](arView, hits2[0])
            }
        }
    }
    
    func notify(of text: String) {
        if notification != nil {
            notifyTimer.invalidate()
            notifyTimer = Timer(timeInterval: 0, repeats: false, block: {(Timer) in})
            UIView.animate(withDuration: 0.25, animations: {
                self.notification?.alpha = 0.0
            }, completion: {(finished: Bool) in
                self.notification?.removeFromSuperview()
                self.notification = nil
            })
        }
        notification = NotificationView(frame: CGRect(x: 20, y: 20, width: 160, height: 30))
        notification!.layer.zPosition = 20
        notification!.alpha = 0.0
        arView.addSubview(notification!)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 160, height: 30))
        label.text = text
        label.textColor = .gray
        label.font = label.font.withSize(14.0)
        label.textAlignment = .center
        label.numberOfLines = 1
        notification!.addSubview(label)
        NSLayoutConstraint.activate([
            notification!.leadingAnchor.constraint(equalTo: arView.leadingAnchor, constant: 20),
            notification!.bottomAnchor.constraint(equalTo: arView.bottomAnchor, constant: 20),
            notification!.widthAnchor.constraint(equalToConstant: 160),
            notification!.heightAnchor.constraint(equalToConstant: 30)
            ])
        print(text)
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.notification?.alpha = 1.0
        }, completion: {(finished: Bool) in
            self.notifyTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(5), repeats: false, block: {(Timer) in
                if self.notification != nil {
                    UIView.animate(withDuration: 0.25, animations: {
                        self.notification?.alpha = 0.0
                    }, completion: {(finished: Bool) in
                        self.notification?.removeFromSuperview()
                        self.notification = nil
                    })
                }
            })
        })
    }
    
    func virtualObject(at point: CGPoint) -> SKNode? {
        let hits = arView.hitTest(point, types: .existingPlane)
        if hits.count > 0 {
            return arView.node(for: hits[0].anchor!)
        } else {
            return nil
        }
    }
    
    // MARK: - ARSKViewDelegate
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Create and configure a node for the anchor added to the view's session.
        if objectName != nil {
            let labelNode = SKSpriteNode(imageNamed: "Images/\(objectName!)")
            return labelNode
        } else {
            return nil
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        notify(of: error.localizedDescription)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        notify(of: "Session interrupted")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .normal:
            notify(of: "Tracking")
        case .notAvailable:
            notify(of: "Not available")
        case .limited(.initializing):
            notify(of: "Initializing")
        case .limited(.excessiveMotion):
            notify(of: "Excessive motion")
        case .limited(.insufficientFeatures):
            notify(of: "Insufficient features")
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

class ErrorView: UIViewController {
    override func loadView() {
        view = PlaygroundView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .black
        let errorLabel = UILabel(frame: CGRect(x: 0, y: (view.frame.height - 18) / 2, width: 100, height: 18))
        errorLabel.text = "Please select the object to use before running this page."
        errorLabel.textColor = .white
        errorLabel.textAlignment = .center
        errorLabel.clipsToBounds = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.trailingAnchor),
            errorLabel.topAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.topAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.bottomAnchor)
            ])
    }
}

var vc: UIViewController = ErrorView()
if let val = PlaygroundKeyValueStore.current["objectName"] {
    if case let .string(s) = val {
        vc = ARViewController()
        objectName = s
    }
}
PlaygroundPage.current.liveView = vc
//#-end-hidden-code
//#-editable-code
func shakeCamera(_ layer:SKSpriteNode) {
    let duration = 0.5
    let amplitudeX:Float = 20;
    let amplitudeY:Float = 12;
    let numberOfShakes = duration / 0.04;
    var actionsArray:[SKAction] = [];
    for index in 1...Int(numberOfShakes) {
        let moveX = Float(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2;
        let moveY = Float(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2;
        let shakeAction = SKAction.moveBy(x: CGFloat(moveX), y: CGFloat(moveY), duration: 0.02);
        shakeAction.timingMode = SKActionTimingMode.easeOut;
        actionsArray.append(shakeAction);
        actionsArray.append(shakeAction.reversed());
    }
    
    let actionSeq = SKAction.sequence(actionsArray);
    layer.run(actionSeq);
}

func createNode(_ arView: ARSKView, _ hit: ARHitTestResult) {
    let anchor = ARAnchor(transform: hit.worldTransform)
    arView.session.add(anchor: anchor)
}

onTapFound.append(shakeCamera)
onTapUnfound.append(createNode)

//#-end-editable-code
