class ApplicationsController < ApplicationController
  before_action :set_application, only: %i[show edit update update_status destroy]

  def index
    @applications = current_user.applications.recent
  end

  def show
  end

  def new
    @application = current_user.applications.build(applied_date: Date.current)
  end

  def create
    @application = current_user.applications.build(application_params)

    if @application.save
      redirect_to applications_path, notice: "Application to #{@application.company} added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @application.update(application_params)
      redirect_to applications_path, notice: "Application updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # PATCH /applications/:id/update_status
  #
  # Powers the inline status dropdown on the applications index. Responds
  # with a Turbo Stream that replaces just this row's frame, so the rest
  # of the list (and the page) never reloads.
  def update_status
    if @application.update(status: params[:status])
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to applications_path, notice: "Status updated." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@application, partial: "applications/application", locals: { application: @application }) }
        format.html { redirect_to applications_path, alert: @application.errors.full_messages.to_sentence }
      end
    end
  end

  def destroy
    @application.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@application) }
      format.html { redirect_to applications_path, notice: "Application removed." }
    end
  end

  private

  def set_application
    # Scoped to current_user so nobody can view, edit, or transition an
    # application that isn't theirs by guessing another id.
    @application = current_user.applications.find(params[:id])
  end

  def application_params
    params.require(:application).permit(:company, :role, :status, :applied_date, :notes)
  end
end
