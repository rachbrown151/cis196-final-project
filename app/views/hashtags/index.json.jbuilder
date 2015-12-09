json.array!(@hashtags) do |hashtag|
  json.extract! hashtag, :id, :tag
  json.url hashtag_url(hashtag, format: :json)
end
