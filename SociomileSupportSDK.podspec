#
# Be sure to run `pod lib lint SociomileSupportSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SociomileSupportSDK'
  s.version          = '0.0.2'
  s.summary          = 'SociomileSupportSDK is Sociomile IOS SDK for mobile ios'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'The Sociomile SDK is a conversational experience that provide customer support such as messaging to your platforms.'

  s.homepage         = 'https://github.com/ivosights/sociomile-ios-sdk'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ivosights' => 'meynisa.nur@ivosights.com' }
  s.source           = { :git => 'https://github.com/ivosights/sociomile-ios-sdk.git', :tag => '0.0.2' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.source_files = 'SociomileSupportSDK/Classes/**/*'
  
   s.resource_bundles = {
     'SociomileSupportSDK' => ['SociomileSupportSDK/Assets/*']
   }
   
   s.default_subspecs = 'Release'
   
   s.subspec 'Debug' do |debug|
      debug.source_files = 'SociomileSupportSDK/Classes/**/*.{swift, h, m}', 'SociomileSupportSDK/Information.swift'
      debug.resources = 'SociomileSupportSDK/Assets/**/*.{json, xml, storyboard, xib}', 'SociomileSupportSDK/Information.swift'
      debug.test_spec 'Tests' do |test_spec|
        test_spec.source_files = 'SociomileSupportSDK/Tests/**/*.{swift, h, m}', 'SociomileSupportSDK/Information.swift'
      end
   end
   
   s.subspec 'Release' do |release|
      release.vendored_frameworks = 'Framework/SociomileSupportSDK.framework'
   end

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
  s.dependency 'RxSwift', '6.5.0'
  s.dependency 'RxCocoa', '6.5.0'
  s.dependency 'Alamofire'
  s.dependency 'AlamofireImage', '~> 4.3'
  s.dependency 'ImageSlideshow', '~> 1.9.0'

end
