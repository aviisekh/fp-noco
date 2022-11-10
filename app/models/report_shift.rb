class ReportShift < ApplicationRecord
  belongs_to :scenario, optional: true
end
