class Device < ActiveRecord::Base
    belongs_to :user

    def self.check_device(platform, token, user_id, imei)
        amount_dev = where(platform: platform, token: token, user_id: user_id, imei: imei) 		

        if amount_dev.count == 0

            amount_dev = where(platform: platform, token: token, user_id: user_id, imei: user_id) 	

            if amount_dev.count == 0

                if token.nil? || token == ""
                    token = "#{Time.now.to_i}#{user_id}" 
                end
                create(
                    platform: platform,
                    token: token,
                    user_id: user_id,
                    imei: imei
                    )

                false
            else
                device = amount_dev.first
                device.update(imei: imei)	
            end
        else
            device = amount_dev.first
            if user_id == device.user_id
                device.update(user_id: user_id)	
                true
            else
                device.update(user_id: user_id)		
                true
            end
        end
    end

    def self.valid_device?(imei)
        return true
        #        devices = where(imei: imei)
        #        if devices.count >= 3
        #            false
        #        else
        #            true
        #        end
    end

    def self.is_user_device?(imei, user_id)
        device = where(imei: imei, user_id: user_id).first
        if device.nil?
            if valid_device?(imei)
                true
            else
                false
            end
        else
            true
        end
    end

end
