# Uncomment the next line to define a global platform for your project
platform :ios, '15.4'

def rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'RxGesture'
  pod 'RxCoreLocation'
  pod "RxAnimated"
end

def json
  pod 'SwiftyJSON'
end

def rswift
  pod 'R.swift'
end

def firebase
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'RxFirebase/Firestore'
  pod 'RxFirebase/RemoteConfig'
  pod 'RxFirebase/Database'
  pod 'RxFirebase/Storage'
  pod 'RxFirebase/Auth'
  pod 'CodableFirebase'
end

def loader
  pod 'NVActivityIndicatorView'
end

def image
  pod 'Nuke'
end

target 'GrubChaserRestaurant' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  firebase
  loader
  rx
  json
  rswift
  image

end
