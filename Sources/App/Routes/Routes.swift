import Vapor

extension Droplet {
    func setupRoutes() throws {
        try resource("movie", MovieController.self)
        get("movies", ":user") { request in
            guard let userId = request.parameters["user"] else {
                throw Abort.badRequest
            }
            return try Movie.makeQuery().filter("user", .equals, userId).all().makeJSON()
        }
    }
}
