class VarifyCode < ActiveRecord::Base
  def self.is_used code
    find_by(:code=>code).present?
  end
end
