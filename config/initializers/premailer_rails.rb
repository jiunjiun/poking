Premailer::Rails.config.merge!({
  preserve_styles: false,
  remove_ids: false,
  input_encoding: 'UTF-8',
  generate_text_part: false,
  strategies: [:filesystem, :asset_pipeline, :network]
})
