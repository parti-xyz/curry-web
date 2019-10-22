json.title do
  json.text do
    json.headline @archive.title
  end
end

json.events @archive.documents do |document|
  if document.date.present?
    if document.media_url.present?
      json.media do
        json.url document.media_url
        json.credit document.media_credit
      end
    elsif document.image.file.present?
      json.media do
        json.url request.protocol + request.host_with_port + document.image.lg.url
      end
    end

    json.start_date do
      json.month document.date.strftime('%m')
      json.day document.date.strftime('%d')
      json.year document.date.strftime('%Y')
    end
    json.text do
      json.headline document.title
      json.text document.body + "<p>출처: #{document.source_url}</p>"
    end
  end
end
