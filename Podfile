# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

use_frameworks!

target 'connectSwift' do
  # Comment the next line if you don't want to use dynamic frameworks
  pod 'ConnectSDK', :git => 'https://github.com/ConnectSDK/Connect-SDK-iOS.git', :tag => '1.6.2', :submodules => true

  # Pods for connectSwift

  target 'connectSwiftTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'connectSwiftUITests' do
    # Pods for testing
  end

end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
end
