module Api
  class DataEntriesController < ApplicationController
    skip_before_action :verify_authenticity_token
    
      
    # def index
    #   @data_entry = DataEntries.all
    # end


    def create
      @data_entry = DataEntry.new(data_entry_params)
      if @data_entry.save
        notify_third_party_endpoints
        render json: { message: 'Data entry created successfully' }, status: :created
      else
        render json: { errors: @data_entry.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      @data_entry = DataEntry.find(params[:id])
      if @data_entry.update(data_entry_params)
        notify_third_party_endpoints
        render json: { message: 'Data entry updated successfully' }, status: :ok
      else
        render json: { errors: @data_entry.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def data_entry_params
      params.require(:data_entry).permit(:data)
    end

    # def notify_third_party_endpoints
    #   # Implement the logic to notify third-party endpoints here
    # end


    def notify_third_party_endpoints
      endpoints = YAML.load_file("#{Rails.root}/config/third_party_endpoints.yml")['endpoints']

      endpoints.each do |endpoint|
        RestClient.post(endpoint, @datum.to_json, content_type: :json)
      end
    end

  end
end
