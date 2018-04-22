/*:
 Welcome to Copy & Place! In this playground you will take a picture of an object, send it to the iPad to figure out what it is, and place copies of it around you.

 First, there needs to be a picture that can be scanned for objects. Press "Run Code" and take a picture of something by pressing the white circle

 *If this is the first time using the playground, please select the orientation of your device. If not, you can just tap "Run Code" without selecting an orientation. If you want to change orientation after running, tap the "Change Orientation" button in the corner.*
 
 ![Demo Capture](demo-Capture.mp4)
 *The video above demonstrates how to use this page.*
 
 [**Next Page**](@next)
 */

//#-hidden-code
import UIKit
import AVFoundation
import PlaygroundSupport

func videoOrientation(from orientation: Int) -> AVCaptureVideoOrientation {
    switch orientation {
    case 3:
        return .landscapeRight
    case 4:
        return .landscapeLeft
    case 2:
        return .portraitUpsideDown
    case 1:
        return .portrait
    default:
        return .portrait
    }
}

class PlaygroundView: UIView, PlaygroundLiveViewSafeAreaContainer {}
var frame: CGRect {
    return PlaygroundView().liveViewSafeAreaGuide.layoutFrame
}
var orientation = 0

class Draw: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        //let h = rect.height
        //let w = rect.width
        let color: UIColor = .white
        
        let drect = rect
        let bpath: UIBezierPath = UIBezierPath(rect: drect)
        
        color.set()
        bpath.stroke()
        
        //print("it ran")
        
        //NSLog("drawRect has updated the view")
        
    }
    
}

class CaptureViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    var cameraView: UIView!
    var session: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureButton: UIButton!
    var capturing = false
    
    override func loadView() {
        let newView = PlaygroundView()
        newView.backgroundColor = .black
        cameraView = UIView()
        
        captureButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        captureButton.layer.cornerRadius = 30
        captureButton.clipsToBounds = true
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        captureButton.backgroundColor = .white
        captureButton.layer.zPosition = 10
        captureButton.isUserInteractionEnabled = true
        captureButton.addTarget(nil, action: #selector(self.takePic), for: .touchUpInside)
        let orientationButton = UIButton(frame: CGRect(x: 20, y: 20, width: 200, height: 18))
        orientationButton.setTitle("Change Orientation", for: .normal)
        orientationButton.addTarget(nil, action: #selector(self.changeOrientation), for: .touchUpInside)
        orientationButton.setTitleColor(.white, for: .normal)
        newView.addSubview(orientationButton)
        newView.addSubview(captureButton)
        
        newView.addSubview(cameraView)
        view = newView
        cameraView.clipsToBounds = true
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraView.leadingAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.trailingAnchor),
            cameraView.heightAnchor.constraint(equalTo: cameraView.widthAnchor),
            cameraView.centerYAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.centerYAnchor),
            captureButton.topAnchor.constraint(equalTo: cameraView.bottomAnchor, constant: 40),
            captureButton.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor),
            captureButton.widthAnchor.constraint(equalToConstant: 60),
            captureButton.heightAnchor.constraint(equalToConstant: 60)
            ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        session = AVCaptureSession()
        session!.sessionPreset = .photo
        let backCamera = AVCaptureDevice.default(for: .video)
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera!)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
            return
        }
        
        if error == nil && session!.canAddInput(input) {
            session!.addInput(input)
            stillImageOutput = AVCapturePhotoOutput()
            if session!.canAddOutput(stillImageOutput!) {
                session!.addOutput(stillImageOutput!)
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
                videoPreviewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
                videoPreviewLayer!.connection?.videoOrientation = videoOrientation(from: orientation)
                cameraView.layer.addSublayer(videoPreviewLayer!)
                session!.startRunning()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        videoPreviewLayer!.frame = cameraView.bounds
    }
    
    @objc func takePic() {
        if !capturing {
            capturing = true
            stillImageOutput!.capturePhoto(with: AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg]), delegate: self)
        }
    }
    
    @objc func changeOrientation() {
        let newvc = OrientationViewController()
        PlaygroundPage.current.liveView = newvc
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        PlaygroundKeyValueStore.current["photoval"] = .data(photo.fileDataRepresentation()!)
        PlaygroundPage.current.assessmentStatus = .pass(message: "Now that there is an image to scan, we can move on to the next page to tell the iPad to figure out what it is.  \n\n[**Next Page**](@next)")
        self.capturing = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

class OrientationViewController: UIViewController {
    var portrait = UIButton()
    var portraitUpsideDown = UIButton()
    var landscapeLeft = UIButton()
    var landscapeRight = UIButton()
    
    override func loadView() {
        view = PlaygroundView()
        view.backgroundColor = .white
        let ipad = UIImage(named: "ipad")!.cgImage!
        portrait.setImage(UIImage(cgImage: ipad), for: .normal)
        portraitUpsideDown.setImage(UIImage(cgImage: ipad, scale: 1.0, orientation: .down), for: .normal)
        landscapeLeft.setImage(UIImage(cgImage: ipad, scale: 1.0, orientation: .left), for: .normal)
        landscapeRight.setImage(UIImage(cgImage: ipad, scale: 1.0, orientation: .right), for: .normal)
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
    
    @objc func portraitF() {
        PlaygroundKeyValueStore.current["orientation"] = .integer(1)
        orientation = 1
        let vc = CaptureViewController()
        PlaygroundPage.current.liveView = vc
    }
    
    @objc func portraitUpsideDownF() {
        PlaygroundKeyValueStore.current["orientation"] = .integer(2)
        orientation = 2
        let vc = CaptureViewController()
        PlaygroundPage.current.liveView = vc
    }
    
    @objc func landscapeLeftF() {
        PlaygroundKeyValueStore.current["orientation"] = .integer(3)
        orientation = 3
        let vc = CaptureViewController()
        PlaygroundPage.current.liveView = vc
    }
    
    @objc func landscapeRightF() {
        PlaygroundKeyValueStore.current["orientation"] = .integer(4)
        orientation = 4
        let vc = CaptureViewController()
        PlaygroundPage.current.liveView = vc
    }
}

var vc: UIViewController = OrientationViewController()
if let or = PlaygroundKeyValueStore.current["orientation"] {
    if case let .integer(i) = or {
        orientation = i
        vc = CaptureViewController()
    }
}
PlaygroundPage.current.liveView = vc
//#-end-hidden-code
