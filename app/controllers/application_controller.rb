class ApplicationController < ActionController::Base

  private
  def prepare_meta_tags opts = {}
    title       = opts[:title] || I18n.t('title')
    site        = opts[:site] || ''
    description = opts[:description] || I18n.t('meta.desc')
    keywords    = opts[:keywords] || I18n.t('meta.keywords')

    defaults = {
      # common
      title: title,
      site: site,
      description: description,
      keywords: keywords,

      # facebook
      og: {
        title: site.present? ? "#{site} | #{title}" : title,
        description: description,
        url: request.original_url,
        site_name: title,
        type: opts[:type] || 'website',
        image: opts[:image]
      },

      'apple-mobile-web-app-capable': 'yes',
      'apple-touch-fullscreen': 'yes',

      # twitter: {
      #   card: 'summary',
      #   title: site.present? ? "#{site} | #{title}" : title,
      #   description: description,
      #   url: request.original_url,
      #   image: opts[:image]
      # }
    }

    set_meta_tags defaults
  end
end
