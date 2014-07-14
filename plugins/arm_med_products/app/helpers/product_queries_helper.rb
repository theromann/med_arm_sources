module ProductQueriesHelper
  # Retrieve query from session or build a new query
  def retrieve_query
    if params[:query_id].present?
      cond = "project_id IS NULL"
      @query = ProductQuery.find(params[:query_id], :conditions => cond)
      session[:products_query] = { :id => @query.id }
      sort_clear
    elsif api_request? || params[:set_filter] || session[:products_query].nil?
      # Give it a name, required to be valid
      @query = ProductQuery.new(:name => "_")
      @query.build_from_params(params)
      session[:products_query] = {:filters => @query.filters, :group_by => @query.group_by, :column_names => @query.column_names}
    else
      @query = retrieve_product_query_from_session
    end
  end

  def retrieve_conditions
    session[:products_search_query] = params[:products_search_query] unless params[:products_search_query].nil?
    session[:products_search_fields] = params[:products_search_fields] if params[:form_send_detector]
    @conditions = Product.search_conditions_from_query(session[:products_search_query], session[:products_search_fields])
  end
end