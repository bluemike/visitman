class Event < ActiveRecord::Base

  ACTIVE_VALUES = [["aktiv",true],["inaktiv",false]]

  validates_presence_of :title, :description, :is_from_date, :is_to_date, :teacher_reg_from_date, :teacher_reg_to_date, :student_reg_from_date, :student_reg_to_date, :default_slot_duration, :message => "Dieses Feld darf nicht leer sein!"

  def getActiveValue (active)
    ACTIVE_VALUES.each do | value, key |
      if active == key
        return value
      end
    end
    return "n/a"
  end

end
