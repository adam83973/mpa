class ReportsController < ApplicationController

  def new
  end

  def show
    @params = params[:query]
    @students = Student.where("
      #{Report::TYPE[params[:query][:type].to_i].downcase.tr(' ', '_')} >= ? AND
      #{Report::TYPE[params[:query][:type].to_i].downcase.tr(' ', '_')} <= ?",
      Date.parse(params[:query][:start_date_range]),
      Date.parse(params[:query][:end_date_range]))
  end
end
