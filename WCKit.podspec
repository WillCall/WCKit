Pod::Spec.new do |s|
  s.name         		= "WCKit"
  s.version      		= "0.0.1"
  s.platform 			= :ios, '5.0'
  s.summary      		= "Physics engine for WillCall."
  s.homepage     		= "http://www.getwillcall.com"
  s.license      		= { :type => 'PRIVATE' }
  s.author       		= { "pat2man" => "pat2man@gmail.com" }
  s.source       		= { :git => "git@github.com:WillCall/WCKit.git", :branch => 'master' }
  s.source_files 		= 'WCPhysics'
  s.public_header_files 	= 'WCPhysics/*.h'
  s.frameworks  		= 'Foundation', 'UIKit', 'QuartzCore'
  s.dependency 			'Chipmunk-Physics', :git => 'git@github.com:pat2man/Chipmunk-Physics.git'
end
