class DailyLocationReportsController < ApplicationController
  before_filter :authorize_employee
  before_filter :authorize_admin

  def index
    @reports = DailyLocationReports.order(:id)

    respond_to do |format|
      format.csv { send_data @reports.to_csv }
    end
  end
end
