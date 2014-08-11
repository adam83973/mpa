class ReportsController < ApplicationController

  def new
  end

  def show
    @params = params[:query]
    if params[:query][:student_status] =! ''
      if params[:query][:start_date_range] != '' && params[:query][:end_date_range] != ''
        @students = Student.where("
          #{Report::TYPE[params[:query][:type].to_i].downcase.tr(' ', '_')} >= ? AND
          #{Report::TYPE[params[:query][:type].to_i].downcase.tr(' ', '_')} <= ? AND
          status = ?",
          Date.parse(params[:query][:start_date_range]),
          Date.parse(params[:query][:end_date_range]),
          Student::STATUSES[params[:query][:student_status].to_i])
      else
        @students = Student.where(:status => params[:query][:student_status])
      end
    else
      @students = Student.where("
        #{Report::TYPE[params[:query][:type].to_i].downcase.tr(' ', '_')} >= ? AND
        #{Report::TYPE[params[:query][:type].to_i].downcase.tr(' ', '_')} <= ?",
        Date.parse(params[:query][:start_date_range]),
        Date.parse(params[:query][:end_date_range]))
    end
  end
end
