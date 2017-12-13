import Vapor
import FluentProvider
import HTTP

final class Movie: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    /// The content of the Movie
    var name: String
    var year: String
    var director: String
    var genre: String
    var rating: String
    var user: String
    
    /// The column names for `id` and `content` in the database
    struct Keys {
        static let nameKey = "name"
        static let yearKey = "year"
        static let directorKey = "director"
        static let genreKey = "genre"
        static let ratingKey = "rating"
        static let userKey = "user"
    }

    /// Creates a new Movie
    init(name: String, rating: String, year: String, director: String, genre: String, user: String) {
        self.name = name
        self.rating = rating
        self.year = year
        self.director = director
        self.genre = genre
        self.user = user
    }

    // MARK: Fluent Serialization

    /// Initializes the Movie from the
    /// database row
    init(row: Row) throws {
        name = try row.get(Movie.Keys.nameKey)
        year = try row.get(Movie.Keys.yearKey)
        rating = try row.get(Movie.Keys.ratingKey)
        director = try row.get(Movie.Keys.directorKey)
        genre = try row.get(Movie.Keys.genreKey)
        user = try row.get(Movie.Keys.userKey)
    }

    // Serializes the Movie to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Movie.Keys.nameKey, name)
        try row.set(Movie.Keys.yearKey, year)
        try row.set(Movie.Keys.ratingKey, rating)
        try row.set(Movie.Keys.directorKey, director)
        try row.set(Movie.Keys.genreKey, genre)
        try row.set(Movie.Keys.userKey, user)
        return row
    }
}

// MARK: JSON

// How the model converts from / to JSON.
// For example when:
//     - Creating a new Movie (Movie /Movies)
//     - Fetching a Movie (GET /Movies, GET /Movies/:id)
//
extension Movie: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            name: json.get(Movie.Keys.nameKey),
            rating: json.get(Movie.Keys.ratingKey),
            year: json.get(Movie.Keys.yearKey),
            director: json.get(Movie.Keys.directorKey),
            genre: json.get(Movie.Keys.genreKey),
            user: json.get(Movie.Keys.userKey)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Movie.idKey, id)
        try json.set(Movie.Keys.nameKey, name)
        try json.set(Movie.Keys.ratingKey, rating)
        try json.set(Movie.Keys.yearKey, year)
        try json.set(Movie.Keys.directorKey, director)
        try json.set(Movie.Keys.genreKey, genre)
        try json.set(Movie.Keys.userKey, user)
        return json
    }
}

extension Movie: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Posts
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Movie.Keys.nameKey)
            builder.string(Movie.Keys.yearKey)
            builder.string(Movie.Keys.ratingKey)
            builder.string(Movie.Keys.directorKey)
            builder.string(Movie.Keys.genreKey)
            builder.string(Movie.Keys.userKey)
        }
    }
    
    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        //try database.delete(self)
    }
}

// MARK: HTTP

// This allows Movie models to be returned
// directly in route closures
extension Movie: ResponseRepresentable { }

// MARK: Update

// This allows the Movie model to be updated
// dynamically by the request.
extension Movie: Updateable {
    // Updateable keys are called when `Movie.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<Movie>] {
        return [
            // If the request contains a String at key "content"
            // the setter callback will be called.
            //UpdateableKey(Movie.Keys.idKey, String.self) { movie, content in
                //movie.id = content
            //}
        ]
    }
}
