class ReportsController < ApplicationController

  def new
  end

  def show
    @params = params[:query]

    # check to see if date ranges are empty as well as date type. Report will not work if date_type is specified and date range does not exist
    # the same goes if there is a date range but not a date_type
    if !(params[:query][:type].empty?) && (params[:query][:start_date_range].empty? || params[:query][:end_date_range].empty?)
      redirect_to new_report_path, notice: "You must enter a date range."
    else
      # check to see if status is empty
      if params[:query][:student_status] != ""
        # if date range exists search based on student status date_type and date range
        if params[:query][:start_date_range] != "" && params[:query][:end_date_range] != ""
          @students = Student.where("
            #{Report::TYPE[params[:query][:type].to_i].downcase.tr(' ', '_')} >= ? AND
            #{Report::TYPE[params[:query][:type].to_i].downcase.tr(' ', '_')} <= ? AND
            status = ?",
            Date.parse(params[:query][:start_date_range]),
            Date.parse(params[:query][:end_date_range]),
            Student::STATUSES[params[:query][:student_status].to_i])
        else
          # only returns if status is the only selection.
          @students = Student.where(:status => Student::STATUSES[params[:query][:student_status].to_i])
        end
      else
        # queries date_type based on date_range without status
        @students = Student.where("
          #{Report::TYPE[params[:query][:type].to_i].downcase.tr(' ', '_')} >= ? AND
          #{Report::TYPE[params[:query][:type].to_i].downcase.tr(' ', '_')} <= ?",
          Date.parse(params[:query][:start_date_range]),
          Date.parse(params[:query][:end_date_range]))
      end
    end
  end
end
