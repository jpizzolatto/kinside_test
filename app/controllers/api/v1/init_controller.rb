require 'uri'
require 'net/http'

class Api::V1::InitController < ApplicationController

    def do_http_request(url, params)
        uri = URI(url)
        if params.present?
            uri.query = URI.encode_www_form(params)
        end
        res = Net::HTTP.get_response(uri)
        if res.is_a?(Net::HTTPSuccess)
            return res.body
        end
        return nil
    end

    # GET /api/v1/init
    def index
        logger.info "Starting Init API"
        # Get movies
        logger.debug "Requesting Movies data from HTTP request"
        movies_data = do_http_request("https://0zrzc6qbtj.execute-api.us-east-1.amazonaws.com/kinside/movies", nil)
        if movies_data.nil?
            return render json: { message: 'Error to do HTTP request for Movies.' }, status: 400
        end
        logger.debug "Done getting Movies data"

        # Get Actors
        logger.debug "Requesting Actors data from HTTP request"
        actors_data = do_http_request("https://0zrzc6qbtj.execute-api.us-east-1.amazonaws.com/kinside/actors", nil)
        if actors_data.nil?
            return render json: { message: 'Error to do HTTP request for Actors.' }, status: 400
        end
        logger.debug "Done getting Actors data"

        # Return data to requester
        render json: { message: "Done requesting Movies and Actors data." }, status: 200
    end

end
