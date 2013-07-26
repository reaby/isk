class SchedulesController < ApplicationController
	def index
		@schedules = Schedule.all
	end
	
	def show
		@schedule = Schedule.find(params[:id])
	end
	
	def new
		@schedule = Schedule.new
	end
	
	def create
		Schedule.transaction do
			@schedule = Schedule.new(params[:schedule])
			if @schedule.save
				flash[:notice] = "Schedule created"
			else
				flash[:error] = "Error creating schedule"
				render :edit and return
			end
		end
		redirect_to :action => :show, :id => @schedule.id
	end
	
	def edit
		@schedule = Schedule.find(params[:id])
		@new_event = ScheduleEvent.new
	end
	
	def update
		Schedule.transaction do
			@schedule = Schedule.find(params[:id])
			
			if @schedule.update_attributes(params[:schedule])
				flash[:notice] = 'Schedule updated'
				redirect_to :action => :show, :id => @schedule.id
			else
				flash[:error] = "Error updating schedule"
				render :edit
			end
			
		end
	end
	
	def add_event
		Schedule.transaction do 
			@schedule = Schedule.find(params[:id])
			event = @schedule.schedule_events.new 
			event.update_attributes(params[:schedule_event])
			redirect_to :action => :show, :id => @schedule.id
		end
	end
	
end
