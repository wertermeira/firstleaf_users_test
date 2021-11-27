class UserSearchQuery
  attr_accessor :query

  def initialize(query)
    @query = query
  end

  def call
    search_in_fields
  end

  private

  def search_in_fields
    columns = %w[email full_name metadata phone_number]
    User.where(
      columns
        .map { |column| "#{column} like :search" }
        .join(' OR '),
      search: "%#{query}%"
    )
  end
end
