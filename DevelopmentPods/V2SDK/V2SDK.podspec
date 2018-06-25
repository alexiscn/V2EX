Pod::Spec.new do |s|
  s.name         = 'V2SDK'
  s.version      = '0.0.2'
  s.license = 'MIT'
  s.requires_arc = true
  s.source = { :path => 'DevelopmentPods/V2SDK' }

  s.summary = 'V2SDK'
  s.homepage = 'No homepage'
  s.author       = { 'xushuifeng' => 'shuifengxu@gmail.com' }
  s.platform     = :ios
  s.ios.deployment_target = '10.0'
  s.source_files = '*.swift'

  s.dependency 'GenericNetworking'
  s.dependency 'SwiftSoup'
  
end
