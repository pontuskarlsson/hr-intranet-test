
FactoryGirl.define do
  factory :leave_of_absence, :class => Refinery::Employees::LeaveOfAbsence do
    employee
    absence_type_id Refinery::Employees::LeaveOfAbsence::TYPE_ANNUAL_LEAVE
    status Refinery::Employees::LeaveOfAbsence::STATUS_APPROVED
    start_date '2014-01-20'


    factory :leave_of_absence_sick_leave do
      absence_type_id Refinery::Employees::LeaveOfAbsence::TYPE_SICK_LEAVE
    end
  end
end

