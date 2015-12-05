class User < ActiveRecord::Base

  SEX_VALUES = [["männlich",1],["weiblich",2]]
  ROLE_TYPE_VALUES = [["Controller",80],["Manager",90],["Administrator",99]]
  ACTIVE_VALUES = [["aktiv",true],["inaktiv",false]]

  ROLE_TYPE_JURY = 1
  ROLE_TYPE_MANAGER = 90
  ROLE_TYPE_ADMIN = 99

  validates_uniqueness_of :email, :message => "Diese Email wird schon verwendet!"
  validates_presence_of :email, :password, :message => "Dieses Feld darf nicht leer sein!"

  def getFirstnameAndNameString user_id
    user = find_by_id(user_id)
    if user != nil
      return user.firstname + " " + user.name
    end
    return "n/a"
  end


  def getSexValue (sex)
    SEX_VALUES.each do | value, key |
      if sex == key
        return value
      end
    end
    return "n/a"
  end

  def getRoleTypeValue (role_type)
    ROLE_TYPE_VALUES.each do | value, key |
      if role_type == key
        return value
      end
    end
    return "n/a"
  end

  def getActiveValue (active)
    ACTIVE_VALUES.each do | value, key |
      if active == key
        return value
      end
    end
    return "n/a"
  end

  def find_by_email (email)
    find_by email: email
  end

  def find_by_id (id)
    if (id != nil && id!="")
      User.find(id)
    else
      return nil
    end
  end

end
