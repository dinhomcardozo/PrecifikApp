WickedPdf.configure do |config|
  config.layout = 'pdf.html'
  config.orientation = 'Portrait'
  config.page_size = 'A4'
  config.margin = { top: 10, bottom: 10, left: 10, right: 10 }
end
