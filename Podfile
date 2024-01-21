
platform :ios, '16.0'
pod 'SwiftLint'

target 'AnimalBrowser' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for AnimalBrowser
  pod 'FSPagerView'
  pod 'SkeletonView'
  pod 'SDWebImage'
  
  target 'AnimalBrowserTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
    end
  end
end
