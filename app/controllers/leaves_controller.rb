class LeavesController < ApplicationController
  before_filter :find_leave,      except: [:new, :create]

  def new
    @leave = current_refinery_user.leaves.build
  end

  def create
    @leave = current_refinery_user.leaves.build(params[:leave])
    if @leave.save
      event = Refinery::Calendar::Event.new(from: @leave.starts_at, to: @leave.ends_at, title: "#{ @leave.user.full_name } - Annual Leave")
      event.save
      @leave.event = event
      @leave.save
      redirect_to '/employee/annual-leave'
    else
      render action: :new
    end
  end

private
  def find_leave
    @leave = current_refinery_user.leaves.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to '/'
  end

end
