class ProductsController < ApplicationController
  unloadable
  before_filter :authorize
  prepend_before_filter :new_product, only: [:new, :create]
  before_filter :find_product, only: [:show, :edit, :update, :destroy, :receipt_one]
  before_filter :find_group_resources, only: [:index]

  helper :sort
  include SortHelper
  helper :queries
  include QueriesHelper
  helper :product_queries
  include ProductQueriesHelper
  helper :issues
  include IssuesHelper

  def show
    @journals = @product.journals.includes(:user, :details).reorder("#{Journal.table_name}.id ASC").all
    @journals.each_with_index {|j,i| j.indice = i+1}
    # @journals.reverse! if User.current.wants_comments_in_reverse_order?
  end

  def index
    retrieve_query
    retrieve_conditions
    sort_init(@query.sort_criteria.empty? ? [['id', 'desc']] : @query.sort_criteria)
    sort_update(@query.sortable_columns)
    @query.sort_criteria = sort_criteria.to_a

    if @query.valid?
      case params[:format]
        when 'csv'
          # @limit = Setting.issues_export_limit.to_i
        else
          @limit = per_page_option
      end
      @products_count = @query.products_count(products_search_params)
      @products_pages = Paginator.new @products_count,
                                        @limit, params[:page]
      @offset ||= @products_pages.offset

      @products =  @query.products(products_search_params)
      @product_count_by_group = @query.product_count_by_group
      respond_to do |format|
        format.html # index.html.haml
        format.csv  { send_data(query_to_csv(@products, @query, params), :type => 'text/csv; header=present', :filename => 'products.csv') }
      end
    else
      @products_count = 0
      @products_pages = Paginator.new @products_count, 1
      @products = []
      respond_to do |format|
        format.html { render(:template => 'products/index', :layout => !request.xhr?) }
        format.any(:csv) { render(:nothing => true) }
      end
    end

  end

  # def new
  # end

  def create
    respond_to do |format|
      if @product.save
        format.html { redirect_to products_path, notice:l(:notice_successful_create)} # пока редирект на Index
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { redirect_to products_path }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    return unless update_product_from_params
  end

  def update
    return unless update_product_from_params
    respond_to do |format|
      if @product.save
        default_storage = StorageProductCount.where(product_id: @product).last
        default_storage.storage_id = @product.location_id
        default_storage.save
        # if params[:receipt_one_form].present?
          format.html { redirect_to :back ,notice:l(:notice_successful_update) }
        # else
        #   format.html { redirect_to @product,notice:l(:notice_successful_update) }
        #   format.json { head :no_content }
        # end
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_path }
      format.js
      format.api  { render_api_ok }
    end
  end

  private
  def new_product
    @product = Product.new(params[:product])
  end

  def find_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def retrieve_product_query_from_session
    @query = ProductQuery.find_by_id(session[:products_query][:id]) if session[:products_query] && session[:products_query][:id]
    @query ||= ProductQuery.new(name: '_',
                                 filters: session[:products_query][:filters],
                                 group_by: session[:products_query][:group_by],
                                 column_names: session[:products_query][:column_names])
  end

  def products_search_params
    {
        include: [
            :location#, :status
        ],
        order: sort_order,
        conditions: @conditions,
        offset: @offset,
        limit: @limit,
        products_group_ids: params[:products_group_ids],
        product_storage_ids: params[:product_storage_ids],
        product_status_names: params[:product_status_names]
    }
  end

  def sort_order
    sort_init 'id', 'desc'
    sort_update(  'id' => 'products.id',
                  'name' => 'products.name',
                  'note' => 'products.note',
                  'status' => 'products.status_name',
                  # 'group' => 'enumerations.name', # TODO: сделать сортировку по группам, пока не знаю как
                  'product_item' => 'products.product_item',
                  'unit' => 'products.unit'
    )
    sort_clause
  end

  def update_product_from_params
    @product.init_journal(User.current)

    action_attributes = params[:product]
    @product.safe_attributes = action_attributes
    true
  end

  def find_group_resources
    @products_groups = ProductsGroup.scoped
    @product_storages = ProductStorage.scoped
    @product_statuses = Product.pluck(:status_name).uniq
  end

  def authorize(ctrl = params[:controller], action = params[:action], global = false)
    allowed = User.current.allowed_to?({controller: ctrl, action: action}, :system)
    if allowed
      true
    else
      render_403
    end
  end
end
