if Rails.application.config.respond_to?(:sass)
  Rails.application.config.sass.tap do |sass|

    sass.load_paths.tap do |load_paths|
      load_paths << File.join(Rails.root, 'private', 'plugin_assets')
    end

    sass.line_comments    = Rails.env.production? ? false : true
    sass.preferred_syntax = :scss
  end
  Rails.application.config.sass.load_paths.each do |load_path|
    Sass.load_paths << load_path
  end
end