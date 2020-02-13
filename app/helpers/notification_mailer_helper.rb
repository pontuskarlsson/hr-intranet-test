 module NotificationMailerHelper

   def initialize_from_notification(notification)
     case notification.key
     when 'plan.confirmed' then attach_plan_contract(notification)
     end

     super
   end

   def attach_plan_contract(notification)
     plan = notification.notifiable

     if plan&.contract&.resource
       attachments[plan.contract.resource.file.name] = plan.contract.resource.file.file.read
     end
   end

 end
