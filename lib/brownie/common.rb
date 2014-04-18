module Brownie
	class Common
         def self.domain
            staging = "wwwcie.ups.com"
            production = "onlinetools.ups.com"
            return staging if ENV["RAILS_ENV"]

            if self.environment.nil?
               staging
            elsif self.environment == "production"
                  production
               else
                staging
            end
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