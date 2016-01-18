module ReportsHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {from: params[:from], to: params[:to], phd: params[:phd], od: params[:od], reviewed: params[:reviewed], sort: column, direction: direction}, {:class => css_class}
  end
end
