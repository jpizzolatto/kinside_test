class Api::V1::ActorsController < ApplicationController

    # Method to select top 5 co-actors for a given actor ID
    def select_co_actors(id, limit)
        # This query is selecting all Actors that is part of the movies where the given clientID is part of as well
        # After getting all movies for each actor, we group by actor ID and order by count
        # this way it will have a list of the most common co-actors from top to bottom, limtting by the limit specified
        @coactors = Actor.select("a.id,a.first_name,a.last_name")
                         .from("actors a")
                         .joins("INNER JOIN movies m ON a.id = ANY(m.\"actorIds\")")
                         .where("a.id <> ?", id)
                         .where("m.id = ANY(:movieIds)", 
                            movieIds: Actor.select("mm.id")
                                            .from("actors aa")
                                            .joins("inner join movies mm ON aa.id = ANY(mm.\"actorIds\")")
                                            .where("aa.id = ?", id)
                                            .group("aa.id,mm.id"))
                        .group("a.id")
                        .order("count(a.id) DESC")
                        .limit(limit)
        return @coactors.as_json
    end

    # GET /api/v1/actors
    def index
        actorIds = request.query_parameters['ids']
        if actorIds.nil?
            logger.info "No id specified, getting data for all actors"
            @ret = Actor.all
            return render json: @ret
        end

        arrayIds = actorIds.split(',')
        co_actors_map = {}
        # Get basic information for the requested actors
        @ret = Actor.select("id,first_name,last_name")
                    .where("id IN (?)", arrayIds)

        # Query for each actor the top-5 co-actors
        arrayIds.each do |id| 
            co_actors_map[id] = select_co_actors(id, 5)
        end

        data = @ret.as_json
        # Iterating over actors JSON to add the co_actors data
        data.each do |actor|
            coactors = co_actors_map[actor["id"]]
            actor["top_co_actors"] = coactors
        end
                    
        logger.info "Got Actors data from ids #{actorIds}"
        render json: data
    end

end
