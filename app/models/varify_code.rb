class VarifyCode < ActiveRecord::Base

  def self.is_used code
    find_by(:code=>code).present?
  end

  def self.is_logout code
    user = VarifyCode.find_by_code code
    return   user[:has_validate]
  end

end
