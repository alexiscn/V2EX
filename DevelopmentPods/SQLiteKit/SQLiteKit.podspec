Pod::Spec.new do |s|
  s.name         = 'SQLiteKit'
  s.version      = '0.0.13'
  s.license = 'MIT'
  s.requires_arc = true
  s.source = { :git => 'https://github.com/alexiscn/SQLiteKit.git', :tag => s.version.to_s }

  s.summary         = 'SQLiteKit based on Swift Codable and Mirror API'
  s.homepage        = 'https://github.com/alexiscn/SQLiteKit'
  s.license         = { :type => 'MIT' }
  s.author          = { 'xushuifeng' => 'shuifengxu@gmail.com' }
  s.platform        = :ios
  s.swift_version   = '4.0'
  s.source_files    =  '**/*.{swift}'
  s.ios.deployment_target = '10.0'
  s.library = 'sqlite3'
  
end
