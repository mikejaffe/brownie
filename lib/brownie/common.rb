module Brownie
	class Common
         def self.domain

            env = Object.const_defined?(:Rails) ? Rails.env : nil
            staging = "wwwcie.ups.com"
            production = "onlinetools.ups.com"

            if !env.nil?
               if !env.to_s.eql?("production")
                 return staging
               end
            end
            if ENV["ENV"].nil?
              return staging 
            end
            
            return staging unless ENV["ENV"].eql?("production")
            return production
         end

         def self.template_to_hash(template,root="ShipmentConfirmRequest")
            xml_path = File.join(File.dirname(File.expand_path(__FILE__)), "../../xml/#{template}.xml")
            digest_xml_file = File.open(xml_path, "rb")
            xml = digest_xml_file.read
            hash = Hash.from_xml(xml)
            hash[root]
         end
	end
end