import Flutter
import UIKit

// Classic explicit-engine pattern instead of the newer scene-based implicit
// engine (FlutterImplicitEngineDelegate + UIApplicationSceneManifest): the
// implicit-engine path has a real race where FlutterViewController's
// viewDidLoad can fire before the engine finishes attaching, causing a null
// platformTaskRunner and a SIGSEGV in VSyncClient — reliably reproducible on
// a cold standalone launch (i.e. tapping the icon, not running via Xcode/
// flutter run, since the debugger's overhead happens to mask the race). See
// https://github.com/flutter/flutter/issues/183900. Creating the engine here
// eagerly, before any window/scene exists, removes the race entirely.
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // super.application(...) is what actually creates self.window and loads
    // Main.storyboard's FlutterViewController (+ its engine) in this classic
    // lifecycle. Registering plugins against `self` BEFORE that exists hands
    // some plugins (mobile_scanner, at least) a registrar with nothing real
    // behind it yet — SIGSEGV inside MobileScannerPlugin.register(with:).
    // Calling super first, then registering, fixes it.
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    GeneratedPluginRegistrant.register(with: self)
    return result
  }
}
