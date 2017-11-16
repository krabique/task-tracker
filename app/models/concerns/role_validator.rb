# frozen_string_literal: true

class RoleValidator < ActiveModel::Validator
  def validate(record)
    record.errors[:base] << 'Only one role is allowed' if
      record.manager_role == true && record.developer_role == true
  end
end
