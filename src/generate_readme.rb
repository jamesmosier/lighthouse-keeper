require 'erb'
require 'json'


sites = Dir.chdir('results') do
  Dir.glob('*').select { |f| File.directory? f }
end

latest_jsons = sites.map do |site|
  Dir.glob(File.join('results', site, '*.json')).max_by(&File.method(:ctime))
end.reject(&:nil?)

items = latest_jsons.map do |json|
  data = JSON.parse(File.read(json), symbolize_names: true)

  {
    json: json,
    requested_url: data.dig(:requestedUrl),
    created_at: data.dig(:fetchTime),
    performance: data.dig(:categories, :performance, :score),
    accessibility: data.dig(:categories, :accessibility, :score),
    best_practices: data.dig(:categories, :"best-practices", :score),
    seo: data.dig(:categories, :seo, :score),
    pwa: data.dig(:categories, :pwa, :score)
  }
end

# Create template.
template = %q{
  ## Lighthouse

  **Updated at <%= Time.now %> by [CircleCI #<%= ENV['CIRCLE_BUILD_NUM'] %>](<%= ENV['CIRCLE_BUILD_URL'] %>)**

  **This report was automatically generated by [Lighthouse Keeper](https://github.com/itinerisltd/lighthouse-keeper)*

  | URL | Performance | Accessibility | Best Practices | SEO | PWA | Updated At |
  | --- | --- | --- | --- | --- | --- | --- |
  % items.each do |item|
    | [<%= item.dig(:requested_url) %>](./<%= item.dig(:json) %>) | <%= item.dig(:performance) %> | <%= item.dig(:accessibility) %> | <%= item.dig(:best_practices) %> | <%= item.dig(:seo) %> | <%= item.dig(:pwa) %> | <%= item.dig(:created_at) %> |
  % end
}.gsub(/^ +/, '')

erb = ERB.new(template, 0, "%<>")

File.open('README.md', 'a') do |f|
  f.write erb.result
end
