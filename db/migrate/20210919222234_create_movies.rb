class CreateMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :year
      t.string :runtime
      t.text :genres, array: true, default: []
      t.string :director
      t.string :plot
      t.string :posterUrl
      t.integer :rating
      t.text :actorIds, array: true, default: []
      t.string :pageUrl

      t.timestamps
    end
  end
end
