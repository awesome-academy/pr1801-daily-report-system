class ReportsController < ApplicationController
  before_action :logged_in_user, only: [:index, :new, :create, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :find_report, only: [:show, :approve, :reject]
  before_action :set_current_user

  def index
    if current_user.manager?
      @reports = Report.load_data.same_division
      if params[:q]
        @reports = Report.same_division.where("status LIKE ? OR content LIKE ?", "%#{params[:q]}%", "%#{params[:q]}%")
        find_status
      else
        @reports
      end
    else
      @reports = current_user.reports.load_data
      if params[:q]
        @reports = current_user.reports.where("status LIKE ? OR content LIKE ?", "%#{params[:q]}%", "%#{params[:q]}%")
        find_status_user
      else
        @reports
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    @report.status = Report.statuses[:pending]
    if @report.update_attributes(report_params)
      flash[:success] = t("update_report")
      redirect_to @report
    else
      render :edit
    end
  end

  def new
    @report = Report.new
  end

  def create
    @report = current_user.reports.build report_params
    if @report.save
      flash[:success] = t("create")
      redirect_to user_path(current_user)
    else
      render "/"
    end
  end

  def destroy
    @report.destroy
    if @report.destroyed?
      flash[:success] = t("deleted")
      redirect_to request.referrer || @reports
    else
      flash[:error] = t("error")
      redirect_to @reports
    end
  end

  def approve
    if @report.verify(current_user)
      redirect_to @report, notice: t("approved")
    else
      redirect_to reports_path, notice: t("error")
    end
  end

  def reject
    if @report.reject(current_user)
      redirect_to @report, notice: t("rejected")
    else
      redirect_to reports_path, notice: t("error")
    end
  end

  private
  def report_params
    params.require(:report).permit(:content, :reported_at, :status)
  end

  def correct_user
    @report = current_user.reports.find_by id: params[:id]
    redirect_to user_path(current_user) if @report.nil?
  end

  def find_report
    @report = Report.find_by id: params[:id]
    if @report.nil?
      render file: "public/404.html", status: :not_found
    else
      render :show
    end
  end

  def find_status
    if params[:q] == "approved"
      @reports = Report.same_division.where("status = '1'")
    elsif params[:q] == "rejected"
      @reports = Report.same_division.where("status = '2'")
    elsif params[:q] == "pending"
      @reports = Report.same_division.where("status = '0'")
    end
  end

  def find_status_user
    if params[:q] == "approved"
      @reports = current_user.reports.where("status = '1'")
    elsif params[:q] == "rejected"
      @reports = current_user.reports.where("status = '2'")
    elsif params[:q] == "pending"
      @reports = current_user.reports.where("status = '0'")
    end
  end
end
