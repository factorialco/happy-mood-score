module EventsHelper
  def filter_text(period)
    case period
    when 'week'
      I18n.t('high5Activity.lastWeek')
    when 'month'
      I18n.t('high5Activity.lastMonth')
    when 'quarter'
      I18n.t('high5Activity.lastQuarter')
    when 'year'
      I18n.t('high5Activity.lastYear')
    else
      I18n.t('high5Activity.showAll')
    end
  end
end
