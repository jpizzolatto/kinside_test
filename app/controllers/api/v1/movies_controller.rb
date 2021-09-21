class Api::V1::MoviesController < ApplicationController

    # GET /api/v1/movies
    def index
        movieIds = request.query_parameters['ids']
        if movieIds.nil?
            logger.info "No id specified, getting data for all movies"
            @ret = Movie.all
            return render json: @ret
        end

        # Generate the select columns to properly get Actors data with movies data
        movieColums = "m.id,m.title,m.year,m.runtime,m.genres,m.director,m.plot,m.\"posterUrl\",m.rating,m.\"pageUrl\","
        actorsColumns = "json_agg(json_build_object('id', a.id,'first_name', a.first_name,'last_name', a.last_name)) as actors"
        # Get movie ids and convert to integer
        arrayIds = movieIds.split(",").map(&:to_i)

        @ret = Movie.select(movieColums + actorsColumns)
                    .from("movies m")
                    .joins("INNER JOIN actors a ON a.id = ANY(m.\"actorIds\")")
                    .where("m.id = ANY(ARRAY#{arrayIds})")
                    .group("m.id")

        logger.info "Got Movies data from ids #{movieIds}"
        render json: @ret
    end

end
