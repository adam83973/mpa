class DailyLocationReportsController < ApplicationController
  before_action :authorize_employee
  before_action :authorize_admin

  def index
    @reports = DailyLocationReport.order(:id)

    respond_to do |format|
      format.csv { send_data @reports.to_csv }
    end
  end
end
