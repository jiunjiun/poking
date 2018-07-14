module AssetsHelper
  def inline_file(path)
    if assets = Rails.application.assets
      asset = assets.find_asset(path)
      return '' unless asset
      asset.source
    else
      File.read(File.join(Rails.root, 'public', ActionController::Base.helpers.asset_path(path)))
    end
  end

  def inline_js path
    _inline_file = inline_file("#{path}.js")
    "<script>#{_inline_file}</script>".html_safe
  end

  def inline_css path
    _inline_file = inline_file("#{path}.css")
    "<style>#{_inline_file}</style>".html_safe
  end
end
