class @AdDisplayer
  ads_skyscraper = ["ad300x600"]
  ads_sm_rectangle = ["ad468x60"]
  ads_full_width = ["adFullWidth"]

  # Note: links have id of binxad-#{ad name} - which enables click tracking with ga events
  max_tracker_300 = "<a id=\"binxad-max_tracker_300\" href=\"https://mymaxtracker.com/\"><img src=\"/ads/maxtracker-300x600-2.jpg\" alt=\"MaxTracker\"></a>"
  max_tracker_468 = "<a id=\"binxad-max_tracker_468\" href=\"https://mymaxtracker.com/\"><img src=\"/ads/maxtracker-468x60-2.jpg\" alt=\"MaxTracker\"></a>"

  internalAds = {
    "max_tracker_300": {
      "href": "https://mymaxtracker.com",
      "body": "<img src=\"/ads/maxtracker-300x600-2.jpg\" alt=\"MaxTracker\">"
    },
    "max_tracker_468": {
      "href": "https://mymaxtracker.com",
      "body": "<img src=\"/ads/maxtracker-468x60-2.jpg\" alt=\"MaxTracker\">"
    }
  }

  skyscrapers = ["max_tracker_300"]
  sm_rectangles = ["max_tracker_468"]
  full_width = []

  constructor: ->
    @renderedAds = []
    # Google ads are rendered on blocks with class .ad-google
    # our ads are rendered on blocks with class .ad-binx

    # TODO: don't use jquery here for the element iterating
    for el_klass in ads_skyscraper
      $(".ad-binx.#{el_klass}").each (index, el) =>
        @renderedAds.push @renderAdElement(el, index, el_klass, skyscrapers)

    for el_klass in ads_sm_rectangle
      $(".ad-binx.#{el_klass}").each (index, el) =>
        @renderedAds.push @renderAdElement(el, index, el_klass, sm_rectangles)

    # ads_full_width are only google right now
    # for el_klass in ads_full_width
    #   $(".ad-binx.#{el_klass}").each (index, el) =>
    #     @renderedAds.push @renderAdElement(el, index, el_klass, full_width)

    # Remove undefined ads (ie they weren't rendered)
    @renderedAds = @renderedAds.filter (x) ->
      x != undefined

    # TODO: not tracking google ad loading. Should be tracking it too.
    # If google analytics is loaded, create an event for each ad that is loaded, and track the clicks
    if window.ga
      for adname in @renderedAds
        window.ga("send", {hitType: "event", eventCategory: "advertisement", eventAction: "ad-load", eventLabel: "#{adname}"})
        $("#binxad-#{adname}").click (e) ->
          window.ga("send", {hitType: "event", eventCategory: "advertisement", eventAction: "ad-click", eventLabel: "#{adname}"})

  renderAdElement: (el, index, klass, adArray) ->
    # check if element is visible, skip rendering if it isn't
    return unless el.offsetWidth > 0 && el.offsetHeight > 0;
    el.classList.add("rendered-ad")
    if adArray[index]
      renderedAd = internalAds[adArray[index]]
      el.innerHTML = "<a href=\"#{renderedAd.href}\" id=\"binxad-#{adArray[index]}\">#{renderedAd.body}</a>"
      adArray[index]


  # geolocatedAd: ->
  #   location = localStorage.getItem('location')
  #   if location?
  #     # Wrap the string in blank space so it's possible to check for non word chars
  #     location = " #{location.toLowerCase()} "
  #     for match in lemonade_location_matches
  #       # Check if the matching strings are separate words in the location string
  #       expression = ///[^\w]#{match}[^\w]///
  #       return lemonade_ad if location.match(///[^\w]#{match}[^\w]///)
  #   else
  #     # Display it anyway, our location tracking is sort of BS
  #     return lemonade_ad
  #   # return an empty string if there aren't any matches
  #   ''
