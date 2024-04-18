#
# Be sure to run `pod lib lint ZCJSON.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZCJSON'
  s.version          = '0.1.7'
  s.summary          = '这是一个原生增强版json解析库，不需要更改遵循Codable协议，完美符合官方'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  这是一个原生增强版json解析库，不需要更改遵循Codable协议，完美符合官方
                       DESC

  s.homepage         = 'https://github.com/ZClee128/ZCJSON'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ZClee128' => '876231865@qq.com' }
  s.source           = { :git => 'https://github.com/ZClee128/ZCJSON.git', :tag => s.version.to_s }
  s.social_media_url = 'https://www.jianshu.com/u/072b722d9fcc'
  s.swift_version = '5.0'
  s.ios.deployment_target = '9.0'

  s.source_files = 'ZCJSON/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ZCJSON' => ['ZCJSON/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
