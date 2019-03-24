
use_frameworks!
inhibit_all_warnings!

target 'Foodern' do
#dynamic frameworks
 platform :ios, '10.0'
 pod 'Alamofire', '~> 4.7'
 pod 'RealmSwift'
end

target 'FoodernWatch Extension' do
  platform :watchos, '5.1'
  pod 'Alamofire', '~> 4.7'
  pod 'RealmSwift'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.0'
    end
  end
end

